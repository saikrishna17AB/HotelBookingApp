import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import '../pages/signup.dart';
import '../pages/bottomnav.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../hotelowner/owner_bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIN extends StatefulWidget {
  const LogIN({super.key});

  @override
  State<LogIN> createState() => _LogINState();
}

class _LogINState extends State<LogIN> {

  String email="",password="",name="";
  TextEditingController namecontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController mailcontroller=TextEditingController();
  String selectedRole = "User"; // Default role

  Future<void> userLogin() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // ✅ Fetch user details from Firestore and update cache
    var snapshot = selectedRole == "User" 
      ? await DatabaseMethods().getUserbyEmail(email)
      : await DatabaseMethods().getHotelOwnerByEmail(email);

    if (snapshot.docs.isNotEmpty) {
      var ds = snapshot.docs.first;
      await SharedpreferenceHelper().saveUserName(ds["Name"]);
      await SharedpreferenceHelper().saveUserEmail(ds["Email"]);
      await SharedpreferenceHelper().saveUserId(ds["Id"]);
      await SharedpreferenceHelper().saveUserRole(selectedRole);

      // ✅ Redirect to correct Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => selectedRole == "User" ? const Bottomnav() : const OwnerBottomNav()),
        );
      }
    } else {
      // User authenticated but not found in the selected collection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account not found as ${selectedRole}. Please check your role.")),
      );
    }

  } on FirebaseAuthException catch (e) {

    String message = "Something went wrong";

    if (e.code == 'user-not-found') {
      message = "No user found for that email";
    } else if (e.code == 'wrong-password') {
      message = "Wrong password";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,          
            children:[
            Image.asset("images/login.png"),
            SizedBox(height: 5.0,),
            Center(
              child: Text("Login", style: AppWidget.headlinetextstyle(25.0),), 
            ),
              

            SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text("Email", style: AppWidget.normaltextstyle(20.0),),
              ),
            SizedBox(height: 15.0,),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: mailcontroller,
                decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.email, color: Colors.green),
                  hintText: "Enter Email",
                  hintStyle: AppWidget.normaltextstyle(18.0) 
                ),

              ),
            ),


            SizedBox(height: 30.0,),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text("Password", style: AppWidget.normaltextstyle(20.0),),
              ),
                SizedBox(height: 10.0,),
            Container(
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
          decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
          child: TextField(
            obscureText: true,
            controller: passwordcontroller,
            decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.password, color: Colors.green),
              hintText: "Enter Password",
              hintStyle: AppWidget.normaltextstyle(18.0) 
            ),

          ),
        ),

        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedRole = "User"),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: selectedRole == "User" ? const Color.fromARGB(255, 11, 14, 177) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "User",
                    style: TextStyle(
                      color: selectedRole == "User" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => setState(() => selectedRole = "Owner"),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: selectedRole == "Owner" ? const Color.fromARGB(255, 11, 14, 177) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Hotel Owner",
                    style: TextStyle(
                      color: selectedRole == "Owner" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

            SizedBox(height:30.0,),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                Text("Forgot Password?", style: AppWidget.normaltextstyle(18.0),),
              ],),
            ),

            SizedBox(height: 30.0,),
            GestureDetector(
              onTap: (){
                if(mailcontroller.text!="" && passwordcontroller.text!=""){
                  setState(() {
                    email=mailcontroller.text;
                    password=passwordcontroller.text;
                  });
                  userLogin();
                }
              },
              child: Center(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 11, 14, 177), borderRadius: BorderRadius.circular(10),),
                  width: MediaQuery.of(context).size.width/2,
                  child: Center(child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                  ),),),
                ),
              ),
            ),

            SizedBox(height:20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Dont have an account? ", style: AppWidget.normaltextstyle(10.0),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>SignUp()));
                },
                child: Text("SignUp",style: AppWidget.headlinetextstyle(20.0,),),
              ),
            ],)


      ],),),
      ),
    );
  }
}