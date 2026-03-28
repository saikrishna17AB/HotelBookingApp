import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';

class BookingDetail extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final bool isOwner;

  const BookingDetail({super.key, required this.bookingData, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Booking Details", style: AppWidget.headlinetextstyle(24.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "images/hotel1.jpg", 
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                bookingData["hotelName"] ?? "Unknown Hotel",
                style: AppWidget.headlinetextstyle(26.0),
              ),
              const SizedBox(height: 10),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  bookingData["status"] ?? "Booked",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              
              const Divider(),
              const SizedBox(height: 10),
              
              _buildDetailRow(Icons.calendar_month, "Check-in", bookingData["startDate"] ?? "N/A"),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.calendar_month_outlined, "Check-out", bookingData["endDate"] ?? "N/A"),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.person, "Guests", "${bookingData["guests"] ?? "1"}"),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.hotel_outlined, "Rooms", "${bookingData["rooms"] ?? "1"}"),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.money, "Total Amount", "₹${bookingData["totalAmount"] ?? "0"}"),
              
              const SizedBox(height: 30),

              // 🔥 REVIEW SECTION
              if (bookingData["hasFeedback"] == true) ...[
                const Divider(),
                const SizedBox(height: 15),
                Text("Guest Review", style: AppWidget.headlinetextstyle(22.0)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (bookingData["rating"] ?? 0) ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 24,
                          );
                        }),
                      ),
                      if (bookingData["review"] != null && bookingData["review"].toString().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          "\"${bookingData["review"]}\"",
                          style: AppWidget.normaltextstyle(16.0).copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
              
              if (bookingData["hasFeedback"] != true && !isOwner)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showFeedbackDialog(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Rate Hotel",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    isOwner ? "Back" : "Back to My Bookings",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    int rating = 0;
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Rate ${bookingData["hotelName"]}", style: AppWidget.headlinetextstyle(20.0)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Write your feedback (optional)...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  if (rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please provide a rating")));
                    return;
                  }
                  
                  // Save feedback
                  String? username = await SharedpreferenceHelper().getUserName();
                  Map<String, dynamic> feedbackMap = {
                    "rating": rating,
                    "review": feedbackController.text,
                    "username": username ?? "Anonymous",
                    "date": DateTime.now().toIso8601String(),
                  };
                  
                  await DatabaseMethods().addHotelFeedback(bookingData["hotelName"], feedbackMap);
                  await DatabaseMethods().updateBookingFeedbackStatus(bookingData["bookingId"], rating, feedbackController.text);
                  
                  if (context.mounted) {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // back to bookings so it refreshes via stream
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Thank you for your feedback!"),
                      backgroundColor: Colors.green,
                    ));
                  }
                },
                child: const Text("Submit", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
      }
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppWidget.normaltextstyle(16.0).copyWith(color: Colors.grey)),
            Text(value, style: AppWidget.headlinetextstyle(18.0)),
          ],
        )
      ],
    );
  }
}
