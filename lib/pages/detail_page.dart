import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/widget_support.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DetailPage extends StatefulWidget {
  final String name, price, desc, ownerEmail;
  final int totalRooms, currentlyBooked;
  final bool wifi, hdtv;

  const DetailPage({
    super.key,
    required this.desc,
    required this.hdtv,
    required this.wifi,
    required this.name,
    required this.price,
    required this.totalRooms,
    required this.currentlyBooked,
    required this.ownerEmail,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController guestscontroller = TextEditingController();
  TextEditingController roomscontroller = TextEditingController();

  int baseAmount = 0;
  int finalamount = 0;
  int daysDifference = 1;
  int guests = 1;
  int rooms = 1;

  DateTime? startDate;
  DateTime? endDate;

  Stream<QuerySnapshot>? reviewStream;

  @override
  void initState() {
    super.initState();

    int pricePerNight = int.parse(widget.price);

    baseAmount = pricePerNight;   // default 1 night
    finalamount = pricePerNight;  // initial amount
    getReviews();
  }

  getReviews() async {
    reviewStream = await DatabaseMethods().getHotelFeedbacks(widget.name);
    setState(() {});
  }

  // 🔵 SELECT START DATE
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
        _calculateDifference();
      });
    }
  }

  // 🔵 SELECT END DATE
  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
        _calculateDifference();
      });
    }
  }

  // 🔥 CALCULATE DAYS + PRICE
  void _calculateDifference() {
    if (startDate != null && endDate != null) {
      int days = endDate!.difference(startDate!).inDays;

      if (days <= 0) days = 1;

      daysDifference = days;

      baseAmount = int.parse(widget.price) * daysDifference;
      finalamount = baseAmount * rooms;

      setState(() {});
    }
  }

  // 🔵 FORMAT DATE
  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat("dd MMM yyyy").format(date)
        : "Select Date";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔵 IMAGE + BACK BUTTON
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Image.asset(
                      "images/hotel1.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 50.0, left: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                )
              ],
            ),

            // 🔵 CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  Text(
                    widget.name,
                    style: AppWidget.headlinetextstyle(22.0),
                  ),

                  StreamBuilder(
                    stream: reviewStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                         return const Padding(
                           padding: EdgeInsets.symmetric(vertical: 5.0),
                           child: Text("No reviews yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
                         );
                      }
                      double totalRating = 0;
                      for (var doc in snapshot.data!.docs) {
                        totalRating += doc["rating"] ?? 0;
                      }
                      double avgRating = totalRating / snapshot.data!.docs.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 20),
                            const SizedBox(width: 5),
                            Text("${avgRating.toStringAsFixed(1)} (${snapshot.data!.docs.length} reviews)",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      );
                    }
                  ),

                  Text(
                    "₹${widget.price}",
                    style: AppWidget.normaltextstyle(27.0),
                  ),

                  const Divider(thickness: 2),

                  const SizedBox(height: 10),

                  Text(
                    "What this place offers",
                    style: AppWidget.headlinetextstyle(22.0),
                  ),

                  const SizedBox(height: 10),

                  if (widget.wifi)
                    Row(
                      children: [
                        const Icon(Icons.wifi, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text("WiFi",
                            style: AppWidget.normaltextstyle(20.0)),
                      ],
                    ),

                  const SizedBox(height: 5),

                  if (widget.hdtv)
                    Row(
                      children: [
                        const Icon(Icons.tv, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text("HDTV",
                            style: AppWidget.normaltextstyle(20.0)),
                      ],
                    ),

                  const Divider(thickness: 2),

                  const SizedBox(height: 10),

                  Text(
                    "About this place",
                    style: AppWidget.headlinetextstyle(22.0),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    widget.desc,
                    style: AppWidget.normaltextstyle(16.0),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "User Reviews",
                    style: AppWidget.headlinetextstyle(22.0),
                  ),
                  
                  const SizedBox(height: 10),

                  StreamBuilder(
                    stream: reviewStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                         return const Padding(
                           padding: EdgeInsets.only(bottom: 20.0),
                           child: Text("Be the first to leave a review!", style: TextStyle(color: Colors.grey, fontSize: 16)),
                         );
                      }
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length, // show up to 5 latest reviews
                        itemBuilder: (context, index) {
                          var review = snapshot.data!.docs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15.0),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(review["username"] ?? "Anonymous", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.orange, size: 18),
                                        const SizedBox(width: 5),
                                        Text("${review["rating"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                  ],
                                ),
                                if (review["review"] != null && review["review"].toString().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(review["review"], style: const TextStyle(fontSize: 15)),
                                ]
                              ]
                            )
                          );
                        }
                      );
                    }
                  ),

                  const SizedBox(height: 20),

                  // 🔥 BOOKING SECTION
                  Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "₹$finalamount",
                            style: AppWidget.headlinetextstyle(22.0),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "₹${widget.price} × $daysDifference night(s) × $guests guest(s)",
                            style: AppWidget.normaltextstyle(16.0),
                          ),

                          const SizedBox(height: 15),

                          // 🔵 CHECK-IN
                          const Text("Check-in-date"),
                          const Divider(),

                          GestureDetector(
                            onTap: () => _selectStartDate(context),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: Colors.blue),
                                const SizedBox(width: 10),
                                Text(_formatDate(startDate)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // 🔵 CHECK-OUT
                          const Text("Check-out-date"),
                          const Divider(),

                          GestureDetector(
                            onTap: () => _selectEndDate(context),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: Colors.blue),
                                const SizedBox(width: 10),
                                Text(_formatDate(endDate)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // 🔵 GUESTS
                          Text(
                            "Number of Guests",
                            style: AppWidget.normaltextstyle(20.0),
                          ),

                          const SizedBox(height: 5),

                          Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(12, 45, 14, 20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: guestscontroller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "1",
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    int.tryParse(value) != null) {
                                  guests = int.parse(value);
                                } else {
                                  guests = 1;
                                }

                                finalamount = baseAmount * guests;

                                setState(() {});
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 🔵 ROOMS
                          Text(
                            "Number of Rooms",
                            style: AppWidget.normaltextstyle(20.0),
                          ),

                          const SizedBox(height: 5),

                          Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(12, 45, 14, 20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: roomscontroller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "1",
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    int.tryParse(value) != null) {
                                  rooms = int.parse(value);
                                } else {
                                  rooms = 1;
                                }

                                finalamount = baseAmount * rooms;

                                setState(() {});
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 🔥 TOTAL BOX
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Amount",
                                  style: AppWidget.headlinetextstyle(20.0),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "₹$finalamount",
                                  style: AppWidget.headlinetextstyle(24.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (startDate == null || endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text("Please select a Check-in and Check-out date"),
                          ),
                        );
                        return;
                      }

                      String? userId = await SharedpreferenceHelper().getUserId() ?? FirebaseAuth.instance.currentUser?.uid;
                      String? userName = await SharedpreferenceHelper().getUserName();

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
                        return;
                      }

                      // 🔴 Availability Check
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(child: CircularProgressIndicator()),
                      );

                      QuerySnapshot existingBookings = await DatabaseMethods().getHotelBookingsFuture(widget.name);
                      Navigator.pop(context); // hide loading

                      int overlappedRooms = 0;
                      DateFormat format = DateFormat("dd MMM yyyy");
                      DateTime newStart = startDate!;
                      DateTime newEnd = endDate!;

                      for (var doc in existingBookings.docs) {
                        try {
                          Map<String, dynamic> bData = doc.data() as Map<String, dynamic>;
                          DateTime existingStart = format.parse(bData["startDate"]);
                          DateTime existingEnd = format.parse(bData["endDate"]);
                          int bRooms = bData["rooms"] ?? 1;

                          // Check overlap: (StartA < EndB) && (EndA > StartB)
                          if (newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart)) {
                            overlappedRooms += bRooms;
                          }
                        } catch (e) {
                          print("Error parsing dates for availability check: $e");
                        }
                      }

                      if (overlappedRooms + rooms + widget.currentlyBooked > widget.totalRooms) {
                        int available = widget.totalRooms - overlappedRooms - widget.currentlyBooked;
                        if (available < 0) available = 0;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text("Only $available rooms available for selected dates."),
                          ),
                        );
                        return;
                      }

                      String bookingId = randomAlphaNumeric(10);
                      Map<String, dynamic> bookingInfoMap = {
                        "hotelName": widget.name,
                        "startDate": _formatDate(startDate),
                        "endDate": _formatDate(endDate),
                        "guests": guests,
                        "rooms": rooms,
                        "totalAmount": finalamount,
                        "userId": userId,
                        "userName": userName ?? "User",
                        "bookingId": bookingId,
                        "status": "Booked",
                        "ownerEmail": widget.ownerEmail,
                      };

                      await DatabaseMethods().bookHotel(bookingInfoMap, bookingId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Booking successful!"),
                        ),
                      );
                      
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Book Now",
                          style: AppWidget.whitetextstyle(20.0).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}