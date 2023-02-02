import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_commerce/component/customBtn.dart';
import 'package:simple_commerce/screens/bottom_nav_controller.dart';

import '../const/appColors.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(
        () {
          _dobController.text =
              "${picked.day}/ ${picked.month}/ ${picked.year}";
        },
      );
    }
  }

  _sendDataToDB() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(currentUser!.email).set({
      "name": _nameController.text,
      "phone": _phoneController.text,
      "dOB": _dobController.text,
      "gender": _genderController.text,
      "age": _ageController.text,
    }).then((value) {
      Fluttertoast.showToast(msg: "User Data Added");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavController()),
      );
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style:
                      TextStyle(fontSize: 22.sp, color: AppColors.deepOrange),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Enter your name",
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: "Enter your phone number",
                  ),
                ),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Date of birth",
                    suffixIcon: IconButton(
                      // onPressed: () {},
                      onPressed: () => _selectDateFromPicker(context),
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Choose your gender",
                    prefixIcon: DropdownButton<String>(
                      hint: const Text("Select"),
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  decoration: const InputDecoration(
                    hintText: "Enter your age",
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                customButton(
                  "Continue",
                  () {
                    _sendDataToDB();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
