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

  Stream<QuerySnapshot> getallHotels() {
    return FirebaseFirestore.instance.collection("Hotel").snapshots();
  }

  Future bookHotel(Map<String, dynamic> bookingInfo, String bookingId) async {
    return await FirebaseFirestore.instance.collection("Bookings").doc(bookingId).set(bookingInfo);
  }

  Stream<QuerySnapshot> getUserBookings(String userId) {
    return FirebaseFirestore.instance
        .collection("Bookings")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getOwnerBookings(String ownerEmail) {
    return FirebaseFirestore.instance
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

  Future addHotelFeedback(String hotelId, Map<String, dynamic> feedbackData) async {
    return await FirebaseFirestore.instance
        .collection("Hotel")
        .doc(hotelId)
        .collection("Feedbacks")
        .add(feedbackData);
  }

  Stream<QuerySnapshot> getHotelFeedbacks(String hotelId) {
    return FirebaseFirestore.instance
        .collection("Hotel")
        .doc(hotelId)
        .collection("Feedbacks")
        .orderBy("date", descending: true)
        .snapshots();
  }

  Future<void> migrateRatings() async {
    // ONE-TIME MIGRATION SCRIPT
    // Fetch all hotels
    var hotelsSnapshot = await FirebaseFirestore.instance.collection("Hotel").get();
    
    for (var doc in hotelsSnapshot.docs) {
      if (doc.id == (doc.data()["name"] ?? "")) {
        continue; // This is a legacy document serving as a name-based feedback holder. We'll skip migrating onto itself.
      }
      
      String? hotelName = doc.data()["name"];
      if (hotelName != null && hotelName.isNotEmpty) {
        // Fetch feedbacks stored under hotelName
        var oldFeedbacks = await FirebaseFirestore.instance
            .collection("Hotel")
            .doc(hotelName)
            .collection("Feedbacks")
            .get();
            
        // Copy them to the correct hotelId document
        for (var feedback in oldFeedbacks.docs) {
          // Check if this feedback already exists to avoid duplicates
          var existing = await FirebaseFirestore.instance
            .collection("Hotel")
            .doc(doc.id)
            .collection("Feedbacks")
            .where("date", isEqualTo: feedback.data()["date"])
            .where("username", isEqualTo: feedback.data()["username"])
            .get();
            
          if (existing.docs.isEmpty) {
            await FirebaseFirestore.instance
                .collection("Hotel")
                .doc(doc.id)
                .collection("Feedbacks")
                .add(feedback.data());
          }
        }
      }
    }
    print("Migration of ratings completed!");
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
  // 💳 WALLET METHODS
  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return await FirebaseFirestore.instance.collection("users").doc(userId).get();
  }

  Future updateUserWallet(String userId, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"wallet": amount});
  }

  Future updateHotel(String id, Map<String, dynamic> hotelInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Hotel")
        .doc(id)
        .update(hotelInfoMap);
  }
}
 

