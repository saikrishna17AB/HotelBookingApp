import 'package:flutter/material.dart';
import '../services/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateHotel extends StatefulWidget {
  final Map<String, dynamic> hotelData;
  final String hotelId;

  const UpdateHotel({super.key, required this.hotelData, required this.hotelId});

  @override
  State<UpdateHotel> createState() => _UpdateHotelState();
}

class _UpdateHotelState extends State<UpdateHotel> {
  String? ownerEmail;
  File? selectedImage;
  String? existingImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;

  late TextEditingController hotelnamecontroller;
  late TextEditingController hotelchargescontroller;
  late TextEditingController hoteladdresscontroller;
  late TextEditingController hoteldesccontroller;
  late TextEditingController hotelroomscontroller;
  late TextEditingController initialbookedcontroller;
  late TextEditingController hotelcitycontroller;

  bool isWifi = false;
  bool isHdtv = false;
  bool isFood = false;
  bool isPool = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize data from widget.hotelData
    hotelnamecontroller = TextEditingController(text: widget.hotelData["name"]);
    hotelchargescontroller = TextEditingController(text: widget.hotelData["price"].toString());
    hoteladdresscontroller = TextEditingController(text: widget.hotelData["location"]);
    hoteldesccontroller = TextEditingController(text: widget.hotelData["description"]);
    hotelroomscontroller = TextEditingController(text: widget.hotelData["totalRooms"].toString());
    initialbookedcontroller = TextEditingController(text: widget.hotelData["currentlyBooked"].toString());
    hotelcitycontroller = TextEditingController(text: widget.hotelData["city"] ?? "");
    
    existingImageUrl = widget.hotelData["image"];
    isWifi = widget.hotelData["wifi"] ?? false;
    isHdtv = widget.hotelData["hdtv"] ?? false;
    isFood = widget.hotelData["food"] ?? false;
    isPool = widget.hotelData["pool"] ?? false;

    getOnLoad();
  }

  getOnLoad() async {
    ownerEmail = await SharedpreferenceHelper().getUserEmail();
    setState(() {});
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    setState(() {
      isUploading = true;
    });

    try {
      String cloudName = "deuv5q5uj";
      String uploadPreset = "HotelApp";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
      );

      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            // 🔵 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Update Hotel",
                        style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30), // Balance the back button
                ],
              ),
            ),

            const SizedBox(height: 20.0),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // 🔥 INTERACTIVE IMAGE PICKER
                      Center(
                        child: GestureDetector(
                          onTap: () => getImage(),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: selectedImage != null
                                    ? Image.file(
                                        selectedImage!,
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : (existingImageUrl != null && existingImageUrl!.startsWith("http"))
                                        ? Image.network(
                                            existingImageUrl!,
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            existingImageUrl ?? "images/hotel1.jpg",
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                              if (isUploading)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black26,
                                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                                  ),
                                ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                                  child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 HOTEL NAME (READ ONLY)
                      Text("Hotel name (Fixed)", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: hotelnamecontroller,
                        enabled: false,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 PRICE
                      Text("Hotel room price", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: hotelchargescontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter room price",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 TOTAL ROOMS
                      Text("Total Rooms Available", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: hotelroomscontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter total number of rooms",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text("Currently Booked Rooms", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: initialbookedcontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter number of already occupied rooms",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 CITY (READ ONLY)
                      Text("Hotel City (Fixed)", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: hotelcitycontroller,
                        enabled: false,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 ADDRESS (READ ONLY)
                      Text("Hotel Address (Fixed)", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: hoteladdresscontroller,
                        enabled: false,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 SERVICES
                      Text("Services", style: AppWidget.normaltextstyle(20.0)),

                      CheckboxListTile(
                        value: isWifi,
                        onChanged: (val) => setState(() => isWifi = val!),
                        title: const Row(
                          children: [
                            Icon(Icons.wifi),
                            SizedBox(width: 10),
                            Text("WiFi"),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        value: isHdtv,
                        onChanged: (val) => setState(() => isHdtv = val!),
                        title: const Row(
                          children: [
                            Icon(Icons.tv),
                            SizedBox(width: 10),
                            Text("HDTV"),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        value: isFood,
                        onChanged: (val) => setState(() => isFood = val!),
                        title: const Row(
                          children: [
                            Icon(Icons.restaurant),
                            SizedBox(width: 10),
                            Text("Food"),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        value: isPool,
                        onChanged: (val) => setState(() => isPool = val!),
                        title: const Row(
                          children: [
                            Icon(Icons.pool),
                            SizedBox(width: 10),
                            Text("Pool"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 DESCRIPTION
                      Text("Hotel Description", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: hoteldesccontroller,
                        maxLines: 4,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          hintText: "Enter about your hotel",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 UPDATE BUTTON
                      GestureDetector(
                        onTap: () async {
                          if (hotelchargescontroller.text.isEmpty ||
                              hotelroomscontroller.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all required fields")),
                            );
                            return;
                          }

                          String imageUrl = existingImageUrl ?? "images/hotel1.jpg";

                          if (selectedImage != null) {
                            String? uploadedUrl = await uploadToCloudinary(selectedImage!);
                            if (uploadedUrl != null) {
                              imageUrl = uploadedUrl;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Image upload failed. Keeping old image.")),
                              );
                            }
                          }

                          Map<String, dynamic> updatedHotel = {
                            "image": imageUrl,
                            "price": hotelchargescontroller.text,
                            "totalRooms": int.tryParse(hotelroomscontroller.text) ?? 5,
                            "currentlyBooked": int.tryParse(initialbookedcontroller.text) ?? 0,
                            "description": hoteldesccontroller.text,
                            "wifi": isWifi,
                            "hdtv": isHdtv,
                            "food": isFood,
                            "pool": isPool,
                          };

                          await DatabaseMethods().updateHotel(widget.hotelId, updatedHotel);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Hotel updated successfully"),
                            ),
                          );

                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Update Details",
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
