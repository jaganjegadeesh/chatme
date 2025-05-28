import 'dart:io';

import 'package:chatme/view/src/admin/home.dart';
// import 'package:chatme/view/src/pages/pratice_view.dart';
import 'package:chatme/view/src/user/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../db/db.dart';
import 'package:chatme/theme/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;
  // ignore: non_constant_identifier_names
  Map<String, String>? user_data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  bool _formSubmitted = false;
  File? _selectImage;
  UserModel? user;

  @override
  void initState() {
    initaialfun();

    super.initState();
  }

  void fetchData() async {
    user_data = await Db.getData();
    var doc = await firebase.collection('users').doc(user_data?['id']).get();

    if (doc.exists) {
      user = UserModel.fromJson(doc.data()!);
    }
    if (user != null) {
      setState(() {
        _name.text = (user?.name ?? '');
        _email.text = (user?.email ?? '');
        _phone.text = (user?.phone ?? '');
        _dob.text = (user?.dob ?? '');
        _gender.text = (user?.gender ?? '');
        if (user?.imageUrl != null) {
          final tempImage = File(user!.imageUrl);
          _selectImage = tempImage;
        }
      });
    }
  }

  void initaialfun() {
    fetchData();
  }

  Future<void> updatevalidation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    String? imageUrl;
    if (_selectImage != null) {
      // Get local app directory
      final appDir = await getApplicationDocumentsDirectory();

      // Create 'user_image' folder
      final userImageDir = Directory('${appDir.path}/user_image');
      if (!(await userImageDir.exists())) {
        await userImageDir.create(recursive: true);
      }

      // Copy image into 'user_image' folder
      final fileName = basename(_selectImage!.path);
      final localImagePath = '${userImageDir.path}/$fileName';
      final savedImage = await _selectImage!.copy(localImagePath);

      imageUrl = savedImage.path; // Local file path

      // Optional: Delete the temp file
      if (await _selectImage!.exists()) {
        await _selectImage!.delete();
      }
    }
    await firebase.collection('users').doc(user_data?['id']).update({
      "email": _email.text,
      "phone": _phone.text,
      "name": _name.text,
      "dob": _dob.text,
      "gender": _gender.text,
      if (imageUrl != null) "imageUrl": imageUrl,
    });
    LoginModel model = LoginModel(
      id: user_data?['id'],
      email: _email.text,
      name: _name.text,
      phone: _phone.text,
      dob: _dob.text,
      gender: _gender.text,
      imageUrl: imageUrl,
    );
    await Db.setLogin(model: model);

    if (!mounted) return;

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Align(
          alignment: Alignment.center,
          child: Text("Changes Success"),
        ),
      ),
    );

    if (user?.role == 'user') {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Userhome()),
      );
    } else if (user?.role == 'admin') {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Adminhome()),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    final tempImage = File(pickedFile.path);

    setState(() {
      _selectImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(color: AppColors.primaryColor),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Change Details",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            label: Text("Name"),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            label: Text("E-mail"),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else {
                              final regexEmail = RegExp(
                                r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
                              );

                              if (!regexEmail.hasMatch(value)) {
                                return 'Invalid email';
                              } else {
                                return null;
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phone,
                          decoration: const InputDecoration(
                            label: Text("Phone"),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Phone';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _dob,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              _dob.text = DateFormat(
                                'dd-MM-yyyy',
                              ).format(pickedDate);
                            }
                          },
                          decoration: const InputDecoration(
                            label: Text("Date of birth"),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Select a Date';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            style: SegmentedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: const BorderSide(
                                color: Colors.grey,
                              ), // optional: adds border
                              backgroundColor: Colors
                                  .grey[200], // optional: background color
                            ),
                            segments: const <ButtonSegment<String>>[
                              ButtonSegment<String>(
                                value: 'Male',
                                label: Text('Male'),
                                icon: Icon(Icons.man_outlined),
                              ),
                              ButtonSegment<String>(
                                value: 'Female',
                                label: Text('Female'),
                                icon: Icon(Icons.woman_2_rounded),
                              ),
                            ],
                            selected: <String>{_gender.text},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _gender.text = newSelection.first;
                              });
                            },
                          ),
                        ),
                        if (_gender.text.isEmpty && _formSubmitted)
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Please select your gender.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              child: const Row(
                                children: [
                                  Text("Profile"),
                                  SizedBox(width: 15),
                                  Icon(Icons.image),
                                ],
                              ),
                              onPressed: () {
                                _pickImageFromGallery();
                              },
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child:
                                  // ignore: unrelated_type_equality_checks
                                  _selectImage != null && _selectImage != ""
                                      ? Padding(
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: FileImage(_selectImage!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.photo_camera_front_sharp),
                            ),
                          ],
                        ),
                        // ignore: unrelated_type_equality_checks
                        if ((_selectImage == null && _selectImage == "") &&
                            _formSubmitted)
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Please select your Profile.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),

                        const SizedBox(height: 30),
                        _isLoading
                            ? Center(
                                child: LoadingAnimationWidget.fallingDot(
                                  color: const Color.fromARGB(255, 252, 75, 75),
                                  size: 50,
                                ),
                              )
                            : ElevatedButton(
                                statesController: WidgetStatesController(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  shadowColor: const Color.fromARGB(
                                    255,
                                    224,
                                    224,
                                    167,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _formSubmitted = true;
                                  });

                                  if (_formKey.currentState!.validate() &&
                                      _gender.text.isNotEmpty &&
                                      // ignore: unrelated_type_equality_checks
                                      (_selectImage != null &&
                                          // ignore: unrelated_type_equality_checks
                                          _selectImage != "")) {
                                    updatevalidation(context);
                                  }
                                },
                                child: const Text("Confirm"),
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
      ),
      bottomNavigationBar: BottomAppBar(color: AppColors.primaryColor),
      // body: Column(
      //   children: [
      //     Container(
      //       height: 400,
      //       alignment: Alignment.bottomLeft,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(50),
      //           bottomRight: Radius.circular(50),
      //         ),
      //         image: DecorationImage(
      //           image: AssetImage("asset/images/zoro.jpg"),
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 40, right: 40),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: const [
      //                 Text(
      //                   "1.2K",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 Text(
      //                   "Followers",
      //                   style: TextStyle(color: Colors.white70, fontSize: 14),
      //                 ),
      //               ],
      //             ),
      //             Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: const [
      //                 Text(
      //                   "851",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 Text(
      //                   "Photos",
      //                   style: TextStyle(color: Colors.white70, fontSize: 14),
      //                 ),
      //               ],
      //             ),
      //             Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: const [
      //                 Text(
      //                   "1.2K",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 Text(
      //                   "Likes",
      //                   style: TextStyle(color: Colors.white70, fontSize: 14),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Container(
      //       decoration: BoxDecoration(
      //         color: const Color.fromARGB(255, 230, 199, 199),
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(50),
      //           topRight: Radius.circular(50),
      //         ),
      //       ),
      //       child: Column(
      //         children: [
      //           const SizedBox(height: 40),
      //           Padding(
      //             padding: const EdgeInsets.only(left: 40, right: 40),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Column(
      //                   children: [
      //                     Text(
      //                       name,
      //                       style: TextStyle(
      //                         fontSize: 15,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                     Text("Tamil Nadu"),
      //                   ],
      //                 ),
      //                 OutlinedButton(
      //                   onPressed: () {
      //                     debugPrint('Received click');
      //                   },
      //                   child: Padding(
      //                     padding: EdgeInsets.all(15),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [Text('F O L L O W')],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(height: 40),
      //           Text("Photo", style: TextStyle(fontSize: 14)),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
