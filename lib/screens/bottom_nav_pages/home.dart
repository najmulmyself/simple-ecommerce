import 'package:carousel_slider/carousel_slider.dart';
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
  final List<String> _carouselImages = [];

  fetchCarouselImage() async {
    QuerySnapshot qn =
        await firestoreInstance.collection("carousel-slider").get();
    setState(
      () {
        for (int i = 0; i < qn.docs.length; i++) {
          _carouselImages.add(
            qn.docs[i]["img-path"],
          );
          print(
            qn.docs[i]["img-path"],
          );
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchCarouselImage();
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
              const SizedBox(
                height: 10,
              ),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                  items: _carouselImages
                      .map(
                        (item) => Container(
                          margin: const  EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(item),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason) {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
