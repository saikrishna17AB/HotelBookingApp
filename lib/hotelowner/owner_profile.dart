import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';
import '../pages/login.dart';

class OwnerProfile extends StatefulWidget {
  const OwnerProfile({super.key});

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    name = await SharedpreferenceHelper().getUserName();
    email = await SharedpreferenceHelper().getUserEmail();
    
    if (email == null && FirebaseAuth.instance.currentUser != null) {
       email = FirebaseAuth.instance.currentUser?.email;
    }
    setState(() {});
  }

  Future<void> _logout() async {
    await SharedpreferenceHelper().clearUserInfo();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIN()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text("Owner Profile", style: AppWidget.headlinetextstyle(24.0)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔵 Profile Photo
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 80, color: Color.fromARGB(255, 11, 14, 177)),
                  ),
                ),
              ),

              const SizedBox(height: 30.0),

              // 🔵 Name Field
              Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Color.fromARGB(255, 11, 14, 177), size: 30),
                      const SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Owner Name", style: AppWidget.normaltextstyle(16.0)),
                          Text(name ?? "Loading...", style: AppWidget.headlinetextstyle(20.0)),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // 🔵 Email Field
              Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Color.fromARGB(255, 11, 14, 177), size: 30),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Owner Email", style: AppWidget.normaltextstyle(16.0)),
                            Text(email ?? "Loading...", 
                              style: AppWidget.headlinetextstyle(18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40.0),

              // 🔵 Logout Button
              GestureDetector(
                onTap: _logout,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.white, size: 28),
                        const SizedBox(width: 10.0),
                        Text("Log Out", style: AppWidget.whitetextstyle(20.0).copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
