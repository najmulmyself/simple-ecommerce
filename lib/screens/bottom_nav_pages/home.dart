import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_commerce/const/appColors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<String> _carouselImages = [];

  fetchCarouselImage() async {
    QuerySnapshot qn =
        await firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  "ECommerce",
                  style: TextStyle(
                    color: AppColors.deepOrange,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search products here",
                          hintStyle: TextStyle(fontSize: 16),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.deepOrange,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      fetchCarouselImage();
                      // FirebaseFirestore.instance
                      //     .collection("carousel-slider")
                      //     .get()
                      //     .then((qn) {
                      //   qn.docs.forEach((doc) {
                      //     print(doc['img-path']);
                      //   });
                      // });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.deepOrange,
                      ),
                      child: const Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
