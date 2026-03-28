import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import '../hotelowner/ownerhomepage.dart';
import 'package:random_string/random_string.dart';
import '../services/database.dart';

class Hoteldetail extends StatefulWidget {
  const Hoteldetail({super.key});

  @override
  State<Hoteldetail> createState() => _HoteldetailState();
}

class _HoteldetailState extends State<Hoteldetail> {

  bool isWifi = false;
  bool isHdtv = false;
  bool isFood = false;
  bool isPool = false;

  TextEditingController hotelnamecontroller = TextEditingController();
  TextEditingController hotelchargescontroller = TextEditingController();
  TextEditingController hoteladdresscontroller = TextEditingController();
  TextEditingController hoteldesccontroller = TextEditingController();
  TextEditingController hotelroomscontroller = TextEditingController();
  TextEditingController initialbookedcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [

            // 🔵 HEADER
            Center(
              child: Text(
                "Hotel Details",
                style: AppWidget.boldwhitetextstyle(26.0),
              ),
            ),

            SizedBox(height: 20.0),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 20),

                      // 🔥 STATIC IMAGE (as you asked)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "images/hotel1.jpg",
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔹 HOTEL NAME
                      Text("Hotel name", style: AppWidget.normaltextstyle(20.0)),
                      SizedBox(height: 5),
                      TextField(
                        controller: hotelnamecontroller,
                        decoration: InputDecoration(
                          hintText: "Enter Hotel name",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔹 PRICE
                      Text("Hotel room price", style: AppWidget.normaltextstyle(20.0)),
                      SizedBox(height: 5),
                      TextField(
                        controller: hotelchargescontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter room price",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔹 TOTAL ROOMS
                      Text("Total Rooms Available", style: AppWidget.normaltextstyle(20.0)),
                      SizedBox(height: 5),
                      TextField(
                        controller: hotelroomscontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter total number of rooms",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20),

                      Text("Currently Booked Rooms (if any)", style: AppWidget.normaltextstyle(20.0)),
                      SizedBox(height: 5),
                      TextField(
                        controller: initialbookedcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter number of already occupied rooms",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔹 ADDRESS
                      Text("Hotel Address", style: AppWidget.normaltextstyle(20.0)),
                      SizedBox(height: 5),
                      TextField(
                        controller: hoteladdresscontroller,
                        decoration: InputDecoration(
                          hintText: "Enter Hotel Address",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔹 SERVICES
                      Text("Services", style: AppWidget.normaltextstyle(20.0)),

                      CheckboxListTile(
                        value: isWifi,
                        onChanged: (val) => setState(() => isWifi = val!),
                        title: Row(
                          children: [
                            Icon(Icons.wifi),
                            SizedBox(width: 10),
                            Text("WiFi"),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        value: isHdtv,
                        onChanged: (val) => setState(() => isHdtv = val!),
                        title: Row(
                          children: [
                            Icon(Icons.tv),
                            SizedBox(width: 10),
                            Text("HDTV"),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        value: isFood,
                        onChanged: (val) => setState(() => isFood = val!),
                        title: Row(
                          children: [
                            Icon(Icons.restaurant),
                            SizedBox(width: 10),
                            Text("Food"),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        value: isPool,
                        onChanged: (val) => setState(() => isPool = val!),
                        title: Row(
                          children: [
                            Icon(Icons.pool),
                            SizedBox(width: 10),
                            Text("Pool"),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔹 DESCRIPTION
                      Text("Hotel Description", style: AppWidget.normaltextstyle(20.0)),
                      SizedBox(height: 5),
                      TextField(
                        controller: hoteldesccontroller,
                        maxLines: 4,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: "Enter about your hotel",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔥 SUBMIT BUTTON
                      GestureDetector(
                        onTap: () async {

                          // ✅ VALIDATION
                          if (hotelnamecontroller.text.isEmpty ||
                              hotelchargescontroller.text.isEmpty ||
                              hotelroomscontroller.text.isEmpty ||
                              hoteladdresscontroller.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          String addId = randomAlphaNumeric(10);

                          Map<String, dynamic> addHotel = {
                            "image": "images/hotel1.jpg", // 🔥 STATIC IMAGE
                            "name": hotelnamecontroller.text,
                            "price": hotelchargescontroller.text,
                            "totalRooms": int.tryParse(hotelroomscontroller.text) ?? 5,
                            "currentlyBooked": int.tryParse(initialbookedcontroller.text) ?? 0,
                            "location": hoteladdresscontroller.text,
                            "description": hoteldesccontroller.text,
                            "wifi": isWifi,
                            "hdtv": isHdtv,
                            "food": isFood,
                            "pool": isPool,
                            "id": addId,
                          };

                          await DatabaseMethods().addHotel(addHotel, addId);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Hotel uploaded successfully"),
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OwnerHome()),
                          );
                        },
                        child: Center(
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: AppWidget.boldwhitetextstyle(26.0),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}