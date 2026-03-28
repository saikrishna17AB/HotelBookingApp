import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_detail.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream<QuerySnapshot>? bookingStream;

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  getOnTheLoad() async {
    String? userId = await SharedpreferenceHelper().getUserId() ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      bookingStream = await DatabaseMethods().getUserBookings(userId);
      setState(() {});
    }
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Bookings Found"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var ds = snapshot.data!.docs[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetail(
                      bookingData: ds.data() as Map<String, dynamic>,
                      isOwner: false,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              (ds.data() as Map<String, dynamic>)["hotelName"] ?? "Unknown Hotel",
                              style: AppWidget.headlinetextstyle(20.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              (ds.data() as Map<String, dynamic>)["status"] ?? "Booked",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      // 🔥 STAR RATING ON CARD
                      if ((ds.data() as Map<String, dynamic>)["hasFeedback"] == true)
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < ((ds.data() as Map<String, dynamic>)["rating"] ?? 0) ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 18,
                                );
                              }),
                            ),
                            const SizedBox(width: 5),
                            const Text("Rating", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.blue),
                          const SizedBox(width: 5),
                          Text("${(ds.data() as Map<String, dynamic>)["startDate"]} to ${(ds.data() as Map<String, dynamic>)["endDate"]}", style: AppWidget.normaltextstyle(16.0)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Guests: ${(ds.data() as Map<String, dynamic>)["guests"]} | Rooms: ${(ds.data() as Map<String, dynamic>)["rooms"] ?? 1}", style: AppWidget.normaltextstyle(16.0)),
                          Text("₹${(ds.data() as Map<String, dynamic>)["totalAmount"]}", style: AppWidget.headlinetextstyle(20.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Bookings", style: AppWidget.headlinetextstyle(24.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: allBookings(),
      ),
    );
  }
}
