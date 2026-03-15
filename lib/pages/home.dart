import 'package:flutter/material.dart';
import '../services/widget_support.dart';
class Home extends StatefulWidget{
  const Home({super.key});
  
  @override
  State<Home> createState()=> _HomeState();
}

class _HomeState extends State<Home>{
  @override
    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: Colors.white,
        body:SingleChildScrollView(
          child: Container(
            child:Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      
                      child: Image.asset(
                        "images/home.jpg",
                        width:MediaQuery.of(context).size.width,
                        height:280,
                        fit:BoxFit.cover,
                        color: const Color.fromARGB(39, 0, 0, 0),
                        colorBlendMode:BlendMode.darken,
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.only(top: 40.0, left: 20.0),
                      width:MediaQuery.of(context).size.width,
                      height:280,
                      decoration:BoxDecoration(color:Color.fromARGB(36, 0, 0, 0),borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [ 
                              Icon(Icons.location_on, color:Colors.white),
                              SizedBox(width: 10.0),
                              Text("India, Delhi",style: AppWidget.whitetextstyle(20.0)),
                            ],
                          ),
                          SizedBox(height: 30.0,),
                          Text("Hey , Tell us where you want to go",style: AppWidget.whitetextstyle(24.0),),
                          SizedBox(height: 20.0,),
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                            margin: EdgeInsets.only(right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: const Color.fromARGB(93, 255, 255, 255), borderRadius: BorderRadius.circular(30)),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,prefixIcon: Icon(Icons.search,color: const Color.fromARGB(183, 255, 255, 255),), hintText: "Search Places", hintStyle: AppWidget.whitetextstyle(20.0)
                              )
                            ),
                          )
          
                      ],
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child:Text("The most relevant", style: AppWidget.headlinetextstyle(22.0),)
                ),
                SizedBox(height:20.0,),
                Container(
                  height:300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:[
                      Container(
                        margin: EdgeInsets.only(left: 20.0,bottom: 5.0),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset("images/hotel1.jpg",width: MediaQuery.of(context).size.width/1.2,height:220,fit:BoxFit.cover,
                                  )
                                ),
                                SizedBox(height: 10.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    children: [
                                      Text("Surya Palace", style: AppWidget.headlinetextstyle(20.0),),
                                      SizedBox(width: MediaQuery.of(context).size.width/4,),
                                      Text("/Rs2000",style: AppWidget.headlinetextstyle(22.0),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0,bottom: 10.0),
                                  child: Row(children: [
                                    Icon(Icons.location_on, color: Colors.blue,size: 30.0,),
                                    SizedBox(width: 5.0,),
                                    Text("Near Marina Beach, MAS", style: AppWidget.normaltextstyle(20.0),)
                                  ],),
                                )
                              ],)
                          ),
                        ),
                      ),
          
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.only(left: 20.0,bottom: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset("images/hotel2.jpg",width: MediaQuery.of(context).size.width/1.2,height:220,fit:BoxFit.cover,
                                  )
                                ),
                                SizedBox(height: 10.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    children: [
                                      Text("Surya Palace", style: AppWidget.headlinetextstyle(20.0),),
                                      SizedBox(width: MediaQuery.of(context).size.width/4,),
                                      Text("/Rs2000",style: AppWidget.headlinetextstyle(22.0),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0,bottom: 10.0),
                                  child: Row(children: [
                                    Icon(Icons.location_on, color: Colors.blue,size: 30.0,),
                                    SizedBox(width: 5.0,),
                                    Text("Near Marina Beach, MAS", style: AppWidget.normaltextstyle(20.0),)
                                  ],),
                                )
                              ],)
                          ),
                        ),
                      ),
                      
                      
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.only(left: 20.0,bottom: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset("images/hotel3.jpg",width: MediaQuery.of(context).size.width/1.2,height:220,fit:BoxFit.cover,
                                  )
                                ),
                                SizedBox(height: 10.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    children: [
                                      Text("Surya Palace", style: AppWidget.headlinetextstyle(20.0),),
                                      SizedBox(width: MediaQuery.of(context).size.width/4,),
                                      Text("/Rs2000",style: AppWidget.headlinetextstyle(22.0),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0,bottom: 10.0),
                                  child: Row(children: [
                                    Icon(Icons.location_on, color: Colors.blue,size: 30.0,),
                                    SizedBox(width: 5.0,),
                                    Text("Near Marina Beach, MAS", style: AppWidget.normaltextstyle(20.0),)
                                  ],),
                                )
                              ],)
                          ),
                        ),
                      ),
                    
                    
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Discover new places",style: AppWidget.headlinetextstyle(20.0),),
                ),
                SizedBox(height:20.0,),
                Container(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:[
                    Container(
                      margin:EdgeInsets.only(bottom: 5.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    "images/mumbai.jpg",
                                    height: 200,
                                    width: 180,
                                    fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("Mumbai",style:AppWidget.headlinetextstyle(20.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.hotel, color: Colors.blue),
                                    SizedBox(width: 5.0,),
                                    Text("10 Hotels",style:AppWidget.normaltextstyle(18.0),),
                                  ],
                                ),
                              ),
                            ],
                            )
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20.0, bottom: 5.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    "images/mumbai.jpg",
                                    height: 200,
                                    width: 180,
                                    fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("Hyderabad",style:AppWidget.headlinetextstyle(20.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.hotel, color: Colors.blue),
                                    SizedBox(width: 5.0,),
                                    Text("15 Hotels",style:AppWidget.normaltextstyle(18.0),),
                                  ],
                                ),
                              ),
                            ],
                            )
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20.0,bottom: 5.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    "images/mumbai.jpg",
                                    height: 200,
                                    width: 180,
                                    fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("Delhi",style:AppWidget.headlinetextstyle(20.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.hotel, color: Colors.blue),
                                    SizedBox(width: 5.0,),
                                    Text("15 Hotels",style:AppWidget.normaltextstyle(18.0),),
                                  ],
                                ),
                              ),
                            ],
                            )
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20.0,bottom: 5.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    "images/mumbai.jpg",
                                    height: 200,
                                    width: 180,
                                    fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("Bengaluru",style:AppWidget.headlinetextstyle(20.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.hotel, color: Colors.blue),
                                    SizedBox(width: 5.0,),
                                    Text("15 Hotels",style:AppWidget.normaltextstyle(18.0),),
                                  ],
                                ),
                              ),
                            ],
                            )
                        ),
                      ),
                    ),


                  ],),
                ),
                SizedBox(height: 50.0,)
            ],  
          ),
                ),
        ),
    );
  } 
}