import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    userId = await SharedpreferenceHelper().getUserId();
    if (userId != null) {
      // 📡 We'll use a Stream for real-time updates on the wallet page
      setState(() {});
    }
  }

  void _showTopUpDialog() {
    TextEditingController amountController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TopUpSheet(
        userId: userId!,
        currentBalance: int.parse(wallet ?? "0"),
        onSuccess: (newTotal) {
          setState(() {
            wallet = newTotal;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Wallet", style: AppWidget.headlinetextstyle(24.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;
          
          // 💰 Ensure wallet field exists in Firestore if document exists
          if (userData != null && !userData.containsKey("wallet")) {
            DatabaseMethods().updateUserWallet(userId!, "0");
            wallet = "0";
          } else {
            wallet = userData?["wallet"] ?? "0";
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔵 Balance Card
                Container(
                  padding: const EdgeInsets.all(25.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B0E4E), Color(0xFF1E2171)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Current Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("₹$wallet", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text("User Account", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Text("Actions", style: AppWidget.headlinetextstyle(22.0)),
                const SizedBox(height: 20),

                // 🚀 Add Money Button
                GestureDetector(
                  onTap: _showTopUpDialog,
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle, color: Colors.blue, size: 35),
                          const SizedBox(width: 15),
                          Text("Add Money to Wallet", style: AppWidget.normaltextstyle(18.0)),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopUpSheet extends StatefulWidget {
  final String userId;
  final int currentBalance;
  final Function(String) onSuccess;

  const _TopUpSheet({required this.userId, required this.currentBalance, required this.onSuccess});

  @override
  State<_TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<_TopUpSheet> {
  bool isProcessing = false;
  bool isSuccess = false;
  
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void _handleTopUp() async {
    String cardNum = cardController.text.trim();
    String expiry = expiryController.text.trim();
    String cvv = cvvController.text.trim();
    String amount = amountController.text.trim();

    // 🛡️ Enhanced Validation
    if (amount.isEmpty || int.tryParse(amount) == null || int.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid amount")));
      return;
    }
    if (cardNum.length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid 16-digit card number")));
      return;
    }
    // 🗓️ Lenient Expiry Regex (MM/YY or MM/YYYY)
    if (!RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})$").hasMatch(expiry)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter expiry in MM/YY format")));
      return;
    }
    if (cvv.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid 3-digit CVV")));
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // 🕒 Simulate Processing
      await Future.delayed(const Duration(seconds: 2));

      int added = int.parse(amount);
      int newTotal = widget.currentBalance + added;
      
      await DatabaseMethods().updateUserWallet(widget.userId, newTotal.toString());

      if (mounted) {
        setState(() {
          isProcessing = false;
          isSuccess = true;
        });
      }

      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        widget.onSuccess(newTotal.toString());
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transaction Failed: $e"), backgroundColor: Colors.redAccent)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20, left: 20, right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Top-up Wallet", style: AppWidget.headlinetextstyle(22.0)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          if (isSuccess) ...[
            const Center(child: Column(children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 15),
              Text("Recharge Successful!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 30),
            ])),
          ] else if (isProcessing) ...[
            const Center(child: Column(children: [
              SizedBox(height: 30),
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Processing Payment...", style: TextStyle(fontSize: 18, color: Colors.blue)),
              SizedBox(height: 50),
            ])),
          ] else ...[
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter Amount", prefixText: "₹", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: const InputDecoration(labelText: "Card Number", prefixIcon: Icon(Icons.credit_card), border: OutlineInputBorder(), counterText: ""),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: TextField(controller: expiryController, decoration: const InputDecoration(labelText: "Expiry (MM/YY)", border: OutlineInputBorder()))),
                const SizedBox(width: 15),
                Expanded(child: TextField(controller: cvvController, obscureText: true, maxLength: 3, decoration: const InputDecoration(labelText: "CVV", border: OutlineInputBorder(), counterText: ""))),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleTopUp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Add Funds Now", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
