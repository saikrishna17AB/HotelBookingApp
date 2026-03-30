import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map/pages/detail_page.dart';
import 'package:map/services/database.dart';
import '../services/widget_support.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? hotelStream;
  String selectedCity = "Delhi";
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  // Filter values
  double minPrice = 0;
  double maxPrice = 10000;
  double minRating = 0;

  @override
  void initState() {
    super.initState();
    hotelStream = DatabaseMethods().getallHotels();
  }

  // 🔥 DYNAMIC HOTEL LIST WITH PRICE & RATING FILTERS
  Widget allHotels() {
    return StreamBuilder(
      stream: hotelStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No Hotels Found in $selectedCity"));
        }

        // We use a FutureBuilder to wait for all average ratings before filtering
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchHotelsWithRatings(snapshot.data.docs),
          builder: (context, futureSnapshot) {
            if (!futureSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var hotelList = futureSnapshot.data!;

            // 🟢 FILTER BY CITY, SEARCH QUERY, PRICE, AND RATING
            var filteredList = hotelList.where((h) {
              String hCity = h["city"] ?? "Delhi";
              String hName = (h["name"] ?? "").toLowerCase();
              double price = h["numericPrice"] ?? 0;
              double rating = h["avgRating"] ?? 0;

              bool cityMatch = selectedCity == "None" || hCity.toLowerCase() == selectedCity.toLowerCase();
              bool queryMatch = hName.contains(searchQuery.toLowerCase());
              bool priceMatch = price >= minPrice && price <= maxPrice;
              bool ratingMatch = rating >= minRating;

              return cityMatch && queryMatch && priceMatch && ratingMatch;
            }).toList();

            if (filteredList.isEmpty) {
              return const Center(child: Text("No hotels match your search criteria."));
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                var data = filteredList[index];
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(
                      desc: data["description"] ?? "",
                      hdtv: data["hdtv"] ?? false,
                      wifi: data["wifi"] ?? false,
                      price: data["price"] ?? "0",
                      name: data["name"] ?? "No Name",
                      totalRooms: data["totalRooms"] ?? 5,
                      currentlyBooked: data["currentlyBooked"] ?? 0,
                      ownerEmail: data["ownerEmail"] ?? "Legacy",
                    )));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                data["image"] ?? "images/hotel1.jpg",
                                width: double.infinity,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(data["name"] ?? "No Name", style: AppWidget.headlinetextstyle(18.0), overflow: TextOverflow.ellipsis),
                                  ),
                                  Text("₹${data["price"] ?? "0"}", style: AppWidget.headlinetextstyle(20.0)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.orange, size: 16),
                                  const SizedBox(width: 4),
                                  Text("${data["avgRating"].toStringAsFixed(1)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Text("(${data["feedbackCount"]})", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.blue, size: 20),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(data["location"] ?? "Unknown", style: AppWidget.normaltextstyle(16.0), overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        );
      },
    );
  }

  // 🛠️ HELPER TO FETCH RATINGS AND PARSE PRICES FOR ALL HOTELS
  Future<List<Map<String, dynamic>>> _fetchHotelsWithRatings(List<QueryDocumentSnapshot> docs) async {
    List<Map<String, dynamic>> results = [];

    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String hName = data["name"] ?? "";
      
      // Calculate Average Rating by fetching the Feedbacks sub-collection using hotel name (consistent with existing data)
      var feedbackQuery = await FirebaseFirestore.instance.collection("Hotel").doc(hName).collection("Feedbacks").get();
      
      double total = 0;
      int count = feedbackQuery.docs.length;
      if (count > 0) {
        for (var fDoc in feedbackQuery.docs) {
          total += (fDoc.data())["rating"] ?? 0;
        }
      }
      
      double avgRating = count > 0 ? total / count : 0.0;
      
      // Clean Price parsing (removes currency symbols and non-numeric chars)
      String priceStr = data["price"]?.toString() ?? "0";
      priceStr = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
      double numericPrice = double.tryParse(priceStr) ?? 0;

      data["avgRating"] = avgRating;
      data["feedbackCount"] = count;
      data["numericPrice"] = numericPrice;
      results.add(data);
    }
    return results;
  }


  void _showLocationPicker() {
    List<String> cities = ["None", "Delhi", "Mumbai", "Bangalore", "Hyderabad", "Chennai"];
    TextEditingController customCityController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Location", style: AppWidget.headlinetextstyle(22.0)),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: cities.map((city) => ChoiceChip(
                  label: Text(city),
                  selected: selectedCity == city,
                  onSelected: (val) {
                    setState(() {
                      selectedCity = city;
                    });
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: customCityController,
                decoration: InputDecoration(
                  hintText: "Enter City Manually",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check_circle, color: Colors.blue),
                    onPressed: () {
                      if (customCityController.text.isNotEmpty) {
                        setState(() {
                          selectedCity = customCityController.text.trim();
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text("Filter Hotels", style: AppWidget.headlinetextstyle(22.0))),
                  const SizedBox(height: 20),
                  Text("Price Range (₹${minPrice.toInt()} - ₹${maxPrice.toInt()})", style: AppWidget.headlinetextstyle(18.0)),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 0,
                    max: 20000,
                    divisions: 40,
                    activeColor: const Color.fromARGB(255, 11, 14, 177),
                    labels: RangeLabels("₹${minPrice.toInt()}", "₹${maxPrice.toInt()}"),
                    onChanged: (values) {
                      setModalState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Text("Minimum Rating (${minRating.toStringAsFixed(1)}+ Stars)", style: AppWidget.headlinetextstyle(18.0)),
                  Slider(
                    value: minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    activeColor: Colors.orange,
                    label: "$minRating",
                    onChanged: (val) {
                      setModalState(() {
                        minRating = val;
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                         minPrice = 0;
                         maxPrice = 20000;
                         minRating = 0;
                      });
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text("Reset Filters", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 11, 14, 177),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(child: Text("Apply Filters", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ FIX: Use ListView instead of SingleChildScrollView
      body: ListView(
        children: [

          // 🔵 HEADER
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  "images/hotel1.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 40.0, left: 20.0),
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _showLocationPicker(),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white),
                              SizedBox(width: 10),
                              Text("India, $selectedCity",
                                  style:
                                      AppWidget.whitetextstyle(20.0)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white, size: 30),
                          onPressed: () => _showFilterDialog(),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),

                    SizedBox(height: 30),

                    Text(
                      "Hey, Tell us where you want to go",
                      style:
                          AppWidget.whitetextstyle(24.0),
                    ),

                    SizedBox(height: 20),

                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search Places",
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 20),

          // 🔥 DYNAMIC HOTELS
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("The most relevant",
                style: AppWidget.headlinetextstyle(22.0)),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 320,
            child: allHotels(),
          ),

          SizedBox(height: 20),

          // 🔵 DISCOVER
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Discover new places",
                style: AppWidget.headlinetextstyle(20.0)),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCityCard("Mumbai", "images/mumbai.jpg"),
                buildCityCard("Hyderabad", "images/charminar.jpg"),
                buildCityCard("New York", "images/newyork.jpg"),
                buildCityCard("Bali", "images/bali.jpg"),
              ],
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  // 🔥 CITY CARD
  Widget buildCityCard(String city, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCity = city;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.0),
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    imagePath,
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
    
                SizedBox(height: 10),
    
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(city,
                      style:
                          AppWidget.headlinetextstyle(18.0)),
                ),
    
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.hotel,
                          color: Colors.blue, size: 18),
                      SizedBox(width: 5),
                      StreamBuilder(
                        stream: hotelStream,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                             return Text("... Hotels", style: AppWidget.normaltextstyle(16.0));
                          }
                          int count = snapshot.data.docs.where((doc) {
                               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                               return (data["city"] ?? "Delhi").toString().toLowerCase() == city.toLowerCase();
                             }).length;
                          return Text("$count Hotels", style: AppWidget.normaltextstyle(16.0));
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}