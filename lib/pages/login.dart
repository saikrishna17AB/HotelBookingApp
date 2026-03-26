import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import '../pages/signup.dart';
import '../pages/bottomnav.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
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

  Future<void> userLogin() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Bottomnav()),);
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No user found for that email",
              style: TextStyle(fontSize: 18.0, color:Colors.black),
            ),
          ),
        );
      }
      else if(e.code=="wrong-password"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wrong Password provided by the user",
              style: TextStyle(fontSize: 18.0, color:Colors.black),
            ),
          ),
        );
      }
    }
  }



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
    );
  }
}