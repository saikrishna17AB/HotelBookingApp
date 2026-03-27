import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';
import '../pages/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    
    // In case no specific data is there in SharedPrefs but they're logged in
    if (email == null && FirebaseAuth.instance.currentUser != null) {
       email = FirebaseAuth.instance.currentUser?.email;
    }
    setState(() {});
  }

  Future<void> _logout() async {
    await SharedpreferenceHelper().clearUserInfo();
    await FirebaseAuth.instance.signOut();
    // After logging out, clear out standard data and go back to Login page
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile", style: AppWidget.headlinetextstyle(24.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔵 Profile Placeholder Photo
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // Temporarily using login.png as requested, or the icon if it fails
                    child: Image.asset(
                      "images/login.png",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 80, color: Colors.blue);
                      },
                    ),
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
                      const Icon(Icons.person, color: Colors.blue, size: 30),
                      const SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name", style: AppWidget.normaltextstyle(16.0)),
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
                      const Icon(Icons.email, color: Colors.blue, size: 30),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: AppWidget.normaltextstyle(16.0)),
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
