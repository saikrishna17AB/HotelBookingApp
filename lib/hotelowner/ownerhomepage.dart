import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';
import 'hoteldetails.dart';
import '../pages/login.dart';
import '../pages/detail_page.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  String? ownerEmail, ownerName;
  Stream? ownerHotelsStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  getOnLoad() async {
    ownerEmail = await SharedpreferenceHelper().getUserEmail();
    ownerName = await SharedpreferenceHelper().getUserName();
    
    if (ownerEmail != null) {
      // Create a stream that filters hotels by ownerEmail
      ownerHotelsStream = FirebaseFirestore.instance
          .collection("Hotel")
          .where("ownerEmail", isEqualTo: ownerEmail)
          .snapshots();
    }
    setState(() {});
  }

  Widget myHotelsList() {
    return StreamBuilder(
      stream: ownerHotelsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 20),
                Text("You haven't added any hotels yet.", 
                    style: AppWidget.normaltextstyle(18.0)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var ds = snapshot.data.docs[index];
            Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(
                  desc: data["description"] ?? "",
                  hdtv: data["hdtv"] ?? false,
                  wifi: data["wifi"] ?? false,
                  price: data["price"] ?? "0",
                  name: data["name"] ?? "No Name",
                  totalRooms: data["totalRooms"] ?? 5,
                  currentlyBooked: data["currentlyBooked"] ?? 0,
                  ownerEmail: data["ownerEmail"] ?? "Legacy",
                )));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            data["image"] ?? "images/hotel1.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(data["name"] ?? "No Name", 
                                        style: AppWidget.headlinetextstyle(20.0),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Delete Hotel"),
                                          content: const Text("Are you sure you want to remove this hotel?"),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
                                            TextButton(onPressed: () async {
                                              await DatabaseMethods().deleteHotel(ds.id);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hotel deleted successfully")));
                                            }, child: const Text("Yes")),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              // 🔥 DASHBOARD RATINGS
                              FutureBuilder<Stream<QuerySnapshot>>(
                                future: DatabaseMethods().getHotelFeedbacks(data["name"] ?? ""),
                                builder: (context, futureSnapshot) {
                                  if (!futureSnapshot.hasData) return const SizedBox.shrink();
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: futureSnapshot.data,
                                    builder: (context, streamSnapshot) {
                                      if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                                        return const Text("No reviews", style: TextStyle(color: Colors.grey, fontSize: 13));
                                      }
                                      double total = 0;
                                      for (var doc in streamSnapshot.data!.docs) {
                                        total += (doc.data() as Map<String, dynamic>)["rating"] ?? 0;
                                      }
                                      double avg = total / streamSnapshot.data!.docs.length;
                                      return Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.orange, size: 16),
                                          const SizedBox(width: 4),
                                          Text("${avg.toStringAsFixed(1)} (${streamSnapshot.data!.docs.length})", 
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      );
                                    }
                                  );
                                }
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.blue, size: 18),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(data["location"] ?? "Unknown", 
                                        style: AppWidget.normaltextstyle(14.0),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("₹${data["price"] ?? "0"} / Night", 
                                  style: const TextStyle(
                                    color: Colors.green, 
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold
                                  )),
                            ],
                          ),
                        )
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
      backgroundColor: const Color(0xFFF5F5F7),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome,", style: AppWidget.normaltextstyle(18.0)),
                      Text(ownerName ?? "Owner", style: AppWidget.headlinetextstyle(24.0)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await SharedpreferenceHelper().clearUserInfo();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogIN()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
                      ),
                      child: const Icon(Icons.logout, color: Colors.redAccent),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text("My Hotels", style: AppWidget.headlinetextstyle(22.0)),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: myHotelsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Hoteldetail()));
        },
        label: const Text("Add New Hotel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 11, 14, 177),
      ),
    );
  }
}