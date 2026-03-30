import 'package:flutter/material.dart';
import 'dart:async';

class PaymentService {
  /// 💳 SHOW MOCK PAYMENT SHEET
  /// returns true if "payment" is successful
  Future<bool?> showPaymentSheet(BuildContext context, int amount) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _MockPaymentPortal(amount: amount);
      },
    );
  }
}

class _MockPaymentPortal extends StatefulWidget {
  final int amount;
  const _MockPaymentPortal({required this.amount});

  @override
  State<_MockPaymentPortal> createState() => _MockPaymentPortalState();
}

class _MockPaymentPortalState extends State<_MockPaymentPortal> {
  bool isProcessing = false;
  bool isSuccess = false;

  final TextEditingController cardController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void _handlePayment() async {
    if (cardController.text.length < 16 || expiryController.text.isEmpty || cvvController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid card details")),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    // 🕒 Simulate Network Delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isProcessing = false;
      isSuccess = true;
    });

    // 🕒 Show Success State briefly
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pop(context, true); // Return TRUE to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Payment Portal",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          if (isSuccess) ...[
            // ✅ SUCCESS STATE
            Center(
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 15),
                  const Text("Payment Successful!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green)),
                  const SizedBox(height: 10),
                  Text("Amount: ₹${widget.amount}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ] else if (isProcessing) ...[
            // ⏳ LOADING STATE
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(color: Colors.blue, strokeWidth: 3),
                  const SizedBox(height: 25),
                  const Text("Processing secure payment...", style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ] else ...[
            // 💳 CARD FORM
            const Text("Card Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            // Card Number
            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                hintText: "4242 4242 4242 4242",
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                counterText: "",
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                // Expiry
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "MM/YY",
                      labelText: "Expiry",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // CVV
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "123",
                      labelText: "CVV",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      counterText: "",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔵 TOTAL AMOUNT
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Payable", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text("₹${widget.amount}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 🚀 PAY BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
