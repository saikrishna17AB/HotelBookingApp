import 'package:flutter/material.dart';
import '../services/widget_support.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
       child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Stack(children:[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50), 
                  bottomRight: Radius.circular(50),
                ),
                child: Image.asset("images/hotel1.jpg", fit: BoxFit.cover,)
              ),
            ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top:50.0, left:20.0),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(60)),
              child: Icon(Icons.arrow_back, color: Colors.white,size: 30.0,),
            ),
          )
        ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              Text("Hotel Marina", style:AppWidget.headlinetextstyle(22.0),),
              Text("/Rs2000/night", style:AppWidget.normaltextstyle(27.0),),
              Divider(thickness: 2.0,),
              SizedBox(height: 10.0,),
              Text("What this place offers", style: AppWidget.headlinetextstyle(22.0),),
              
              SizedBox(height: 5.0,),
              Row(children:[
                Icon(Icons.wifi, color: const Color.fromARGB(141, 33, 149, 243)),
                SizedBox(width: 10.0,),
                Text("WIFI", style: AppWidget.normaltextstyle(23.0),),
                
              ],),  

              SizedBox(height: 5.0,),
              Row(
                children: [
                  Icon(Icons.tv, color: const Color.fromARGB(141, 33, 149, 243)),
                  SizedBox(width: 10.0,),
                  Text("HDTV", style: AppWidget.normaltextstyle(23.0),),
                  

                ],
              ),
                
              SizedBox(height: 5.0,),
              Row(children:[
                Icon(Icons.kitchen, color: const Color.fromARGB(141, 33, 149, 243)),
                SizedBox(width: 10.0,),
                Text("Kitchen", style: AppWidget.normaltextstyle(23.0),),
              ],),  
                Divider(thickness: 2.0,),
                SizedBox(height: 5.0,),
                Text("About this place", style: AppWidget.headlinetextstyle(22.0),),
                SizedBox(height: 5.0,),
                Text("Experience comfort and luxury at our hotel, where every stay feels like home.Enjoy beautifully designed rooms, delicious dining, and exceptional service.Perfect for business trips, family vacations, or relaxing getaways.Book your stay today and create unforgettable memories with us",style: AppWidget.normaltextstyle(16.0,),),
                SizedBox(height:20.0,),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(10),  
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0,),
                        Text("\Rs 4000 for 2 nights",style: AppWidget.headlinetextstyle(20.0),),
                        SizedBox(height: 5.0,),
                        Text("Check-in-date",style: AppWidget.normaltextstyle(20.0),),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(20),),
                              child: Icon(Icons.calendar_month, color: Colors.white,size: 30.0,),

                            ),
                            SizedBox(width: 10.0,),
                            Text("09,March 2026",style: AppWidget.normaltextstyle(20.0),),
                          ],),


                          SizedBox(height: 5.0,),
                          Text("Check-out-date",style: AppWidget.normaltextstyle(20.0),),
                          Divider(),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(20),),
                                child: Icon(Icons.calendar_month, color: Colors.white,size: 30.0,),

                              ),
                              SizedBox(width: 10.0,),
                              Text("10,March 2026",style: AppWidget.normaltextstyle(20.0),),
                            ],),
                            Text("Number of guests",style: AppWidget.normaltextstyle(20.0),), 
                      ],
                    ),
                  ),
                ),


                
                SizedBox(height:30.0,),
            
            
            ],
          ),
        ),
    
      ],),)
    ),
    );
  }
}