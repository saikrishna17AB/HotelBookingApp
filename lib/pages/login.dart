import 'package:flutter/material.dart';
import '../services/widget_support.dart';

class LogIN extends StatefulWidget {
  const LogIN({super.key});

  @override
  State<LogIN> createState() => _LogINState();
}

class _LogINState extends State<LogIN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

          child:Column(
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
                decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.password, color: Colors.green),
                  hintText: "Enter Password",
                  hintStyle: AppWidget.normaltextstyle(18.0) 
                ),

              ),
            ),

            Row(children:[
              Text("Forgot Password?", style: AppWidget.)
            ],),

            SizedBox(height: 30.0,),
            Center(
              child: Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10),),
                width: MediaQuery.of(context).size.width/2,
                child: Center(child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                ),),),
              ),
            ),

            SizedBox(height:20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Already have an account? ", style: AppWidget.normaltextstyle(10.0),),
              Text("LogIn",style: AppWidget.headlinetextstyle(20.0,),),
            ],)


      ],),),
    );
  }
}