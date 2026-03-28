import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String selectedCity = "Delhi";
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

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
          return Center(child: Text("No Hotels Found in $selectedCity"));
        }

        // 🟢 FILTER BY CITY AND SEARCH QUERY
        var filteredList = snapshot.data.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String hCity = data["city"] ?? "Delhi"; // Default for legacy data
          String hName = (data["name"] ?? "").toLowerCase();
          
          bool cityMatch = selectedCity == "None" || hCity.toLowerCase() == selectedCity.toLowerCase();
          bool queryMatch = hName.contains(searchQuery.toLowerCase());
          
          return cityMatch && queryMatch;
        }).toList();

        if (filteredList.isEmpty) {
          return Center(child: Text("No hotels match your search criteria."));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            var ds = filteredList[index];
            Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
            
            return GestureDetector(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: 
                  (context)=> DetailPage(
                  desc: data["description"] ?? "",
                  hdtv: data["hdtv"] ?? false,
                  wifi: data["wifi"] ?? false,
                  price: data["price"] ?? "0",
                  name: data["name"] ?? "No Name",
                  totalRooms: data["totalRooms"] ?? 5,
                  currentlyBooked: data["currentlyBooked"] ?? 0,
                  ownerEmail: data["ownerEmail"] ?? "Legacy",
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
                            data["image"] ?? "images/hotel1.jpg",
                            width: double.infinity,
                            height: 130,
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
                                  data["name"] ?? "No Name",
                                  style:
                                      AppWidget.headlinetextstyle(18.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "₹${data["price"] ?? "0"}",
                                style:
                                    AppWidget.headlinetextstyle(20.0),
                              ),
                            ],
                          ),
                        ),
              
                        SizedBox(height: 2),
  
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: FutureBuilder<Stream<QuerySnapshot>>(
                            future: DatabaseMethods().getHotelFeedbacks(data["name"] ?? ""),
                            builder: (context, futureSnapshot) {
                              if (!futureSnapshot.hasData) return SizedBox.shrink();
                              return StreamBuilder<QuerySnapshot>(
                                stream: futureSnapshot.data,
                                builder: (context, streamSnapshot) {
                                  if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                                    return Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.orange, size: 16),
                                        SizedBox(width: 4),
                                        Text("New", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      ],
                                    );
                                  }
                                  double total = 0;
                                  for (var doc in streamSnapshot.data!.docs) {
                                     total += (doc.data() as Map<String, dynamic>)["rating"] ?? 0;
                                  }
                                  double avg = total / streamSnapshot.data!.docs.length;
                                  return Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.orange, size: 16),
                                      SizedBox(width: 4),
                                      Text("${avg.toStringAsFixed(1)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      SizedBox(width: 4),
                                      Text("(${streamSnapshot.data!.docs.length})", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  );
                                }
                              );
                            }
                          )
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
                                  data["location"] ?? "Unknown",
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

  void _showLocationPicker() {
    List<String> cities = ["None", "Delhi", "Mumbai", "Bangalore", "Hyderabad", "Chennai"];
    TextEditingController customCityController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Location", style: AppWidget.headlinetextstyle(22.0)),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: cities.map((city) => ChoiceChip(
                  label: Text(city),
                  selected: selectedCity == city,
                  onSelected: (val) {
                    setState(() {
                      selectedCity = city;
                    });
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: customCityController,
                decoration: InputDecoration(
                  hintText: "Enter City Manually",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check_circle, color: Colors.blue),
                    onPressed: () {
                      if (customCityController.text.isNotEmpty) {
                        setState(() {
                          selectedCity = customCityController.text.trim();
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        );
      }
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
                    GestureDetector(
                      onTap: () => _showLocationPicker(),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          SizedBox(width: 10),
                          Text("India, $selectedCity",
                              style:
                                  AppWidget.whitetextstyle(20.0)),
                        ],
                      ),
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
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
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
            height: 320,
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
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCityCard("Mumbai", "images/mumbai.jpg"),
                buildCityCard("Hyderabad", "images/charminar.jpg"),
                buildCityCard("New York", "images/newyork.jpg"),
                buildCityCard("Bali", "images/bali.jpg"),
              ],
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  // 🔥 CITY CARD
  Widget buildCityCard(String city, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCity = city;
        });
      },
      child: Container(
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
                    imagePath,
                    height: 180,
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
                      StreamBuilder(
                        stream: hotelStream,
                        builder: (context, AsyncSnapshot snapshot) {
                          int count = 0;
                          if (snapshot.hasData) {
                             count = snapshot.data.docs.where((doc) {
                               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                               return (data["city"] ?? "Delhi").toString().toLowerCase() == city.toLowerCase();
                             }).length;
                          }
                          return Text("$count Hotels", style: AppWidget.normaltextstyle(16.0));
                        }
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
  }
}