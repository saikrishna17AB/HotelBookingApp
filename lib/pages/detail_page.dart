import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/widget_support.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DetailPage extends StatefulWidget {
  final String name, price, desc;
  final bool wifi, hdtv;

  const DetailPage({
    super.key,
    required this.desc,
    required this.hdtv,
    required this.wifi,
    required this.price,
    required this.name,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController guestscontroller = TextEditingController();

  int baseAmount = 0;
  int finalamount = 0;
  int daysDifference = 1;
  int guests = 1;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();

    int pricePerNight = int.parse(widget.price);

    baseAmount = pricePerNight;   // default 1 night
    finalamount = pricePerNight;  // initial amount
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
      finalamount = baseAmount * guests;

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

                  // 🔥 BOOKING SECTION
                  Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
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

                      String bookingId = randomAlphaNumeric(10);
                      Map<String, dynamic> bookingInfoMap = {
                        "hotelName": widget.name,
                        "startDate": _formatDate(startDate),
                        "endDate": _formatDate(endDate),
                        "guests": guests,
                        "totalAmount": finalamount,
                        "userId": userId,
                        "userName": userName ?? "User",
                        "bookingId": bookingId,
                        "status": "Booked",
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
                      width: MediaQuery.of(context).size.width,
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