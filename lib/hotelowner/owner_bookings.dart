import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';
import '../pages/booking_detail.dart';

class OwnerBookings extends StatefulWidget {
  const OwnerBookings({super.key});

  @override
  State<OwnerBookings> createState() => _OwnerBookingsState();
}

class _OwnerBookingsState extends State<OwnerBookings> {
  String? ownerEmail;
  Stream? bookingStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  getOnLoad() async {
    ownerEmail = await SharedpreferenceHelper().getUserEmail();
    if (ownerEmail != null) {
      bookingStream = await DatabaseMethods().getOwnerBookings(ownerEmail!);
    }
    setState(() {});
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No bookings yet for your hotels.", style: AppWidget.normaltextstyle(18.0)));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var ds = snapshot.data.docs[index];
            Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetail(bookingData: data, isOwner: true)));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
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
                              child: Text(data["hotelName"] ?? "Hotel", style: AppWidget.headlinetextstyle(18.0)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(data["status"] ?? "Booked", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        // 🔥 STAR RATING ON CARD
                        if (data["hasFeedback"] == true)
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < (data["rating"] ?? 0) ? Icons.star : Icons.star_border,
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
                        Text("Guest: ${data["userName"]}", style: AppWidget.normaltextstyle(16.0)),
                        const SizedBox(height: 5),
                        Text("Dates: ${data["startDate"]} - ${data["endDate"]}", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text("Rooms: ${data["rooms"]} | Guests: ${data["guests"]}", style: const TextStyle(color: Colors.grey)),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Earnings:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("₹${data["totalAmount"]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
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
      appBar: AppBar(
        title: Text("Hotel Bookings", style: AppWidget.headlinetextstyle(24.0)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: allBookings(),
    );
  }
}
