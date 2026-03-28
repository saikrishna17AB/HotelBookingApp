import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods{
  
  Future addUserInfo(Map<String, dynamic> userInfoMap,String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);

  }

  Future addHotel(Map<String, dynamic> hotelinfoMap,String id) async {
    return await FirebaseFirestore.instance.collection("Hotel").doc(id).set(hotelinfoMap);
  }

  Future addHotelOwnerInfo(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance.collection("hotelOwners").doc(id).set(userInfoMap);
  }

  Future deleteHotel(String id) async {
    return await FirebaseFirestore.instance.collection("Hotel").doc(id).delete();
  }

  Future<Stream<QuerySnapshot>> getallHotels() async{
    return await FirebaseFirestore.instance.collection("Hotel").snapshots();
  }

  Future bookHotel(Map<String, dynamic> bookingInfo, String bookingId) async {
    return await FirebaseFirestore.instance.collection("Bookings").doc(bookingId).set(bookingInfo);
  }

  Future<Stream<QuerySnapshot>> getUserBookings(String userId) async {
    return await FirebaseFirestore.instance
        .collection("Bookings")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOwnerBookings(String ownerEmail) async {
    return await FirebaseFirestore.instance
        .collection("Bookings")
        .where("ownerEmail", isEqualTo: ownerEmail)
        .snapshots();
  }

  Future<QuerySnapshot> getUserbyEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> getHotelOwnerByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("hotelOwners")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future addHotelFeedback(String hotelName, Map<String, dynamic> feedbackData) async {
    return await FirebaseFirestore.instance
        .collection("Hotel")
        .doc(hotelName)
        .collection("Feedbacks")
        .add(feedbackData);
  }

  Future<Stream<QuerySnapshot>> getHotelFeedbacks(String hotelName) async {
    return await FirebaseFirestore.instance
        .collection("Hotel")
        .doc(hotelName)
        .collection("Feedbacks")
        .orderBy("date", descending: true)
        .snapshots();
  }

  Future updateBookingFeedbackStatus(String bookingId, int rating, String review) async {
    return await FirebaseFirestore.instance
        .collection("Bookings")
        .doc(bookingId)
        .update({
      "hasFeedback": true,
      "rating": rating,
      "review": review,
    });
  }

  Future<QuerySnapshot> getHotelBookingsFuture(String hotelName) async {
    return await FirebaseFirestore.instance
        .collection("Bookings")
        .where("hotelName", isEqualTo: hotelName)
        .get();
  }
} 

