import 'package:flutter/material.dart';
import 'package:map/pages/detail_page.dart';
import 'package:map/services/database.dart';
import '../services/widget_support.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? hotelStream;

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  getontheload() async {
    hotelStream = await DatabaseMethods().getallHotels();
    setState(() {});
  }

  // 🔥 DYNAMIC HOTEL LIST
  Widget allHotels() {
    return StreamBuilder(
      stream: hotelStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No Hotels Found"));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var ds = snapshot.data.docs[index];

            return GestureDetector(
              onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: 
                (context)=> DetailPage(
                desc: ds["description"] ?? "",
                hdtv: ds["hdtv"] ?? false,
                wifi: ds["wifi"] ?? false,
                price: ds["price"] ?? "0",
                name: ds["name"] ?? "No Name",
                              ),
                ),
              );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            ds["image"] ?? "images/hotel1.jpg",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
              
                        SizedBox(height: 10),
              
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ds["name"] ?? "No Name",
                                  style:
                                      AppWidget.headlinetextstyle(18.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "₹${ds["price"] ?? "0"}",
                                style:
                                    AppWidget.headlinetextstyle(20.0),
                              ),
                            ],
                          ),
                        ),
              
                        SizedBox(height: 5),
              
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15),
                          child: Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.blue, size: 20),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  ds["location"] ?? "Unknown",
                                  style:
                                      AppWidget.normaltextstyle(16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ FIX: Use ListView instead of SingleChildScrollView
      body: ListView(
        children: [

          // 🔵 HEADER
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  "images/hotel1.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 40.0, left: 20.0),
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 10),
                        Text("India, Delhi",
                            style:
                                AppWidget.whitetextstyle(20.0)),
                      ],
                    ),

                    SizedBox(height: 30),

                    Text(
                      "Hey, Tell us where you want to go",
                      style:
                          AppWidget.whitetextstyle(24.0),
                    ),

                    SizedBox(height: 20),

                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search Places",
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 20),

          // 🔥 DYNAMIC HOTELS
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("The most relevant",
                style: AppWidget.headlinetextstyle(22.0)),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 280,
            child: allHotels(),
          ),

          SizedBox(height: 20),

          // 🔵 DISCOVER
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Discover new places",
                style: AppWidget.headlinetextstyle(20.0)),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCityCard("Mumbai"),
                buildCityCard("Hyderabad"),
                buildCityCard("Delhi"),
                buildCityCard("Bengaluru"),
              ],
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  // 🔥 CITY CARD
  Widget buildCityCard(String city) {
    return Container(
      margin: EdgeInsets.only(left: 20.0),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "images/mumbai.jpg",
                  height: 200,
                  width: 180,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(city,
                    style:
                        AppWidget.headlinetextstyle(18.0)),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.hotel,
                        color: Colors.blue, size: 18),
                    SizedBox(width: 5),
                    Text("Hotels",
                        style: AppWidget.normaltextstyle(16.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}