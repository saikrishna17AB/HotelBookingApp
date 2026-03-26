import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import '../pages/login.dart';
import '../pages/bottomnav.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import 'package:map/services/database.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  String email="", password="", name="";
  TextEditingController namecontroller= TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController mailcontroller=TextEditingController();

  Future<void> registration() async {
    if(password !="" && namecontroller.text != "" && mailcontroller.text!= ""){
      try{
        UserCredential userCredential=await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

        //Upload data to firebase
        String id=randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap={
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": id,
          
        };

        await SharedpreferenceHelper().saveUserName(namecontroller.text);
        await SharedpreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedpreferenceHelper().saveUserId(id);

        await DatabaseMethods().addUserInfo(userInfoMap, id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Registered successfully!",
                style: TextStyle(fontSize: 18.0,),
              ),
            ),
          );
          Navigator.push(context,MaterialPageRoute(builder:(context)=> Bottomnav()),);


      } on FirebaseAuthException catch (e) {
        if(e.code == 'weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password provided is too weak",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
        else if(e.code=="email-already-in-use"){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Email ID already exists",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:Container(
        margin:EdgeInsets.only(top: 40.0),  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
          Center(child: Image.asset("images/signup.png", height:300, width:300, fit:BoxFit.cover,)),
          SizedBox(height: 5.0,),
          Center(child: Text("Sign Up", style: AppWidget.headlinetextstyle(25.0),)),
          SizedBox(height: 5.0,),
          Center(
            child: Text(
              "Please enter the details to continue",
              style: AppWidget.normaltextstyle(17.0),
            ),
          ),
          SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text("Name", style: AppWidget.normaltextstyle(20.0),),
          ),
            SizedBox(height: 10.0,),
        Container(
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
          decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: namecontroller,
            decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.person, color: Colors.green),
              hintText: "Enter Name",
              hintStyle: AppWidget.normaltextstyle(18.0) 
            ),

          ),
        ), 
        

        SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text("Email", style: AppWidget.normaltextstyle(20.0),),
          ),
            SizedBox(height: 10.0,),
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

        SizedBox(height: 20.0,),
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

        SizedBox(height: 30.0,),
        GestureDetector(
          onTap:(){
            if(namecontroller.text!="" && mailcontroller.text!="" && passwordcontroller.text!=""){
              setState((){
                email= mailcontroller.text;
                password= passwordcontroller.text;
              });
            }
            registration();
          },
          child: Center(
            child: Container(
              height: 60,
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10),),
              width: MediaQuery.of(context).size.width/2,
              child: Center(child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20.0,
                  fontWeight: FontWeight.bold,
              ),),),
            ),
          ),
        ),

        SizedBox(height:20.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Already have an account? ", style: AppWidget.normaltextstyle(10.0),),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=> LogIN()));
            },
            child: Text("LogIn",style: AppWidget.headlinetextstyle(20.0,),)),
        ],)


      ],),),
      
      ),
    );
  }
}