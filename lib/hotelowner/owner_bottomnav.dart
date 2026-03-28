import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'ownerhomepage.dart';
import 'owner_bookings.dart';
import 'owner_profile.dart';

class OwnerBottomNav extends StatefulWidget {
  const OwnerBottomNav({super.key});

  @override
  State<OwnerBottomNav> createState() => _OwnerBottomNavState();
}

class _OwnerBottomNavState extends State<OwnerBottomNav> {
  late List<Widget> pages;
  late OwnerHome ownerHome;
  late OwnerBookings ownerBookings;
  late OwnerProfile ownerProfile;

  int currentTabIndex = 0;

  @override
  void initState() {
    ownerHome = const OwnerHome();
    ownerBookings = const OwnerBookings();
    ownerProfile = const OwnerProfile();

    pages = [
      ownerHome,
      ownerBookings,
      const Center(child: Text('Wallet Coming Soon', style: TextStyle(fontSize: 20))),
      ownerProfile
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: const Color(0xFFF5F5F7),
        color: const Color.fromARGB(255, 11, 14, 177),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Colors.white, size: 30.0),
          Icon(Icons.list_alt, color: Colors.white, size: 30.0), // Using list icon for bookings
          Icon(Icons.wallet_outlined, color: Colors.white, size: 30.0),
          Icon(Icons.person_outline, color: Colors.white, size: 30.0),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
