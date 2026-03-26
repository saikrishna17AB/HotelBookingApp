import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods{
  
  Future addUserInfo(Map<String, dynamic> userInfoMap,String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);

  }

  Future addHotel(Map<String, dynamic> hotelinfoMap,String id) async {
    return await FirebaseFirestore.instance.collection("Hotel").doc(id).set(hotelinfoMap);

  }

  Future<Stream<QuerySnapshot>> getallHotels() async{
    return await FirebaseFirestore.instance.collection("Hotel").snapshots();
  }
} 

