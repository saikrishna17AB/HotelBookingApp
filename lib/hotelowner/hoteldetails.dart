import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import '../pages/login.dart';
import '../pages/bottomnav.dart';
import '../hotelowner/ownerhomepage.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import 'package:map/services/database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Hoteldetail extends StatefulWidget {
  const Hoteldetail({super.key});

  @override
  State<Hoteldetail> createState() => _HoteldetailState();
}

class _HoteldetailState extends State<Hoteldetail> {

  bool isChecked=false;
  bool isChecked1=false;
  bool isChecked2=false;
  bool isChecked3=false;

  File? selectedImage;
  final ImagePicker _picker=ImagePicker();

  TextEditingController hotelnamecontroller= new TextEditingController();
  TextEditingController hotelchargescontroller= new TextEditingController();
  TextEditingController hoteladdresscontroller= new TextEditingController();
  TextEditingController hoteldesccontroller= new TextEditingController();

Future getImage() async {
  var image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    selectedImage = File(image.path);
    setState(() {});
  }
}
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hotel Details", style: AppWidget.boldwhitetextstyle(26.0),)
              ],
            ), 
            SizedBox(height: 20.0,),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left:20.0,right:20.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                    SizedBox(height: 20.0,),
                    selectedImage!=null? Container(
                      height:200,
                      width: 200,
                      child: ClipRRect(borderRadius:BorderRadius.circular(20),
                              child:
                                Image.file(
                                  selectedImage!, 
                                  fit: BoxFit.cover,
                                )
                              ),
                    )
                    :
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          height:200,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width:2.0, color:Colors.black45)),
                          child: Icon(Icons.camera_alt,color: Colors.blue,size: 35.0,)
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Text("Hotel name",style: AppWidget.normaltextstyle(20.0),),
                    SizedBox(height: 5.0,),
                    Container(
                      padding: EdgeInsets.only(left: 20.0), 
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10),),
                      child: TextField(controller:hotelnamecontroller,decoration:InputDecoration(border: InputBorder.none, hintText: "Enter Hotel name", hintStyle: AppWidget.normaltextstyle(18.0),),)
                    ),
                  
                    SizedBox(height: 20.0,),
                    Text("Hotel room price",style: AppWidget.normaltextstyle(20.0),),
                    SizedBox(height: 5.0,),
                    Container(
                      padding: EdgeInsets.only(left: 20.0), 
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10),),
                      child: TextField(controller:hotelchargescontroller,decoration:  InputDecoration(border: InputBorder.none, hintText: "Enter hotel room charges", hintStyle: AppWidget.normaltextstyle(18.0),),)
                    ),
                  
                    SizedBox(height: 20.0,),
                    Text("Hotel Address",style: AppWidget.normaltextstyle(20.0),),
                    SizedBox(height: 5.0,),
                    Container(
                      padding: EdgeInsets.only(left: 20.0), 
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10),),
                      child: TextField(controller:hoteladdresscontroller,decoration:  InputDecoration(border: InputBorder.none, hintText: "Enter Hotel Address", hintStyle: AppWidget.normaltextstyle(18.0),),)
                    ),
                  
                  
                  
                    SizedBox(height: 20.0,),
                    Text("What service you want to offer?",style: AppWidget.normaltextstyle(20.0),),
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value){
                            setState(() {
                              isChecked=value!;
                            });
                          },
                        ),
                  
                        Icon(
                          Icons.wifi,
                          color:const Color.fromARGB(255, 7, 102, 179),
                          size: 30.0,
                        ),
                        SizedBox(width: 18.0,),
                        Text("WIFI",style: AppWidget.normaltextstyle(23.0),),
                      ],
                    ),
                  
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        Checkbox(
                          value: isChecked1,
                          onChanged: (bool? value){
                            setState(() {
                              isChecked1=value!;
                            });
                          },
                        ),
                  
                        Icon(
                          Icons.wifi,
                          color:const Color.fromARGB(255, 7, 102, 179),
                          size: 30.0,
                        ),
                        SizedBox(width: 18.0,),
                        Text("HDTV",style: AppWidget.normaltextstyle(23.0),),
                      ],
                    ),
                  
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        Checkbox(
                          value: isChecked2,
                          onChanged: (bool? value){
                            setState(() {
                              isChecked2=value!;
                            });
                          },
                        ),
                  
                        Icon(
                          Icons.wifi,
                          color:const Color.fromARGB(255, 7, 102, 179),
                          size: 30.0,
                        ),
                        SizedBox(width: 18.0,),
                        Text("WIFI",style: AppWidget.normaltextstyle(23.0),),
                      ],
                    ),
                  
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        Checkbox(
                          value: isChecked3,
                          onChanged: (bool? value){
                            setState(() {
                              isChecked3=value!;
                            });
                          },
                        ),
                  
                        Icon(
                          Icons.wifi,
                          color:const Color.fromARGB(255, 7, 102, 179),
                          size: 30.0,
                        ),
                        SizedBox(width: 18.0,),
                        Text("WIFI",style: AppWidget.normaltextstyle(23.0),),
                      ],
                    ),
                  
                    SizedBox(height: 20.0,),
                    Text("Hotel Description",style: AppWidget.normaltextstyle(20.0),),
                    SizedBox(height: 5.0,),
                    Container(
                      padding: EdgeInsets.only(left: 20.0), 
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10),),
                      child: TextField(controller:hoteldesccontroller,maxLength:6,decoration: InputDecoration(border: InputBorder.none, hintText: "Enter about your hotel", hintStyle: AppWidget.normaltextstyle(18.0),),)
                    ),

                    SizedBox(height:20.0),
                    GestureDetector(
                      onTap: () async {
                        String addId=randomAlphaNumeric(10);

                        Reference firebaseStorageRef=FirebaseStorage.instance.ref().child("blogImage").child(addId);

                        if (selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select an image")),
                          );
                          return;
                        }
                        final UploadTask task=firebaseStorageRef.putFile(selectedImage!);
                        var downloadUrl=await(await task).ref.getDownloadURL();

                        Map<String,dynamic> addHotel={
                          "Image":downloadUrl,
                          "HotelName":hotelnamecontroller.text,
                          "HotelCharges":hotelchargescontroller.text,
                          "HotelAddress":hoteladdresscontroller.text,
                          "HotelDesc":hoteldesccontroller.text,
                          "Wi-Fi":isChecked?"true":"false",
                          "HDTV":isChecked1?"true":"false",
                          "Food":isChecked2?"true":"false",
                          "Pool":isChecked3?"true":"false",
                          "Id":addId
                        };
                        await DatabaseMethods().addHotel(addHotel,addId);

                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Hotel details have been uploaded!",
                              style: TextStyle(fontSize: 18.0,),
                            ),
                          ),
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> OwnerHome()));
                      },
                      child: Center(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(color:Colors.blue, borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Center(child: Text("Submit",style:AppWidget.boldwhitetextstyle(26.0),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,)

                  
                  
                  
                  ],),
                ),
              ),
            )   
          ],
        ),
      )

    );
  }
}