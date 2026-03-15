import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child:column,

//       )
//     );
//   }
// }

class AppWidget{
  static TextStyle whitetextstyle(double size){
    return TextStyle(color: Colors.white, fontSize: size, fontWeight:FontWeight.w500);
  }

  static TextStyle headlinetextstyle(double size){
    return TextStyle(color: Colors.black, fontSize: size, fontWeight:FontWeight.bold,);
  }
  static TextStyle normaltextstyle(double size){
    return TextStyle(color: Colors.black, fontSize: size, fontWeight:FontWeight.w500,);
  }
}

