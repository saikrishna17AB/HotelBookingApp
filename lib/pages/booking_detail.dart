import 'package:flutter/material.dart';
import '../services/widget_support.dart';

class BookingDetail extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetail({super.key, required this.bookingData});

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
              _buildDetailRow(Icons.money, "Total Amount", "₹${bookingData["totalAmount"] ?? "0"}"),
              
              const SizedBox(height: 30),
              
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
                  child: const Text(
                    "Back to My Bookings",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
