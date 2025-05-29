import 'dart:io';
import 'package:chatme/constant/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatme/theme/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _RegisterState();
}

class _RegisterState extends State<AddProducts> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _color = TextEditingController();
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  bool _formSubmitted = false;
  File? _selectImage;

  final Map<String, MaterialColor> materialColors = {
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Purple': Colors.purple,
    'Pink': Colors.pink,
    'Teal': Colors.teal,
    'Amber': Colors.amber,
    'Indigo': Colors.indigo,
    'Brown': Colors.brown,
  };
  Future<String?> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> registervalidation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_selectImage != null) {
      // Get local app directory
      final appDir = await getApplicationDocumentsDirectory();

      // Create 'user_image' folder
      final userImageDir = Directory('${appDir.path}/user_image');
      if (!(await userImageDir.exists())) {
        await userImageDir.create(recursive: true);
      }

      // Copy image into 'user_image' folder
      basename(_selectImage!.path);
    }
    try {
      String? base64Image;
      if (_selectImage != null) {
        base64Image = await convertImageToBase64(_selectImage!);
      }

      var url = Uri.parse('${Constants.url}shop_product.php');

      Map<String, dynamic> product = {
        "edit": false,
        "name": _name.text,
        "rate": _rate.text,
        "color": _color.text,
        if (base64Image != null) "imageBase64": base64Image,
      };

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        // ignore: avoid_print
        print('Failed to create product: ${response.body} in PHP');
      }

      // Optional: Delete the temp file
      if (await _selectImage!.exists()) {
        await _selectImage!.delete();
      }

      if (!mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Align(
            alignment: Alignment.center,
            child: Text("Add Products Successful"),
          ),
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Registration failed: $e")));
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Product",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: AppColors.primaryColor),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: TextFormField(
                                  controller: _name,
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
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
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter the Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: _pickImageFromGallery,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: _selectImage != null
                                        ? FileImage(_selectImage!)
                                        : null,
                                    child: _selectImage == null
                                        ? const Icon(Icons.person, size: 40)
                                        : null,
                                  ),
                                ),
                                if (_selectImage == null && _formSubmitted)
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                        'select Profile.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _rate,
                          decoration: const InputDecoration(
                            label: Text("Rate"),
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
                              return 'Enter the Rate';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String? selectedColorName =
                                    materialColors.keys.first;

                                return AlertDialog(
                                  title: const Text('Pick a color'),
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return DropdownButton<String>(
                                        value: selectedColorName,
                                        isExpanded: true,
                                        items: materialColors.keys.map((name) {
                                          return DropdownMenuItem(
                                            value: name,
                                            child: Text(name),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              selectedColorName = newValue;
                                              _color.text =
                                                  newValue; // Store the name
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Done'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              controller: _color,
                              decoration: const InputDecoration(
                                label: Text("Color"),
                                border: OutlineInputBorder(),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select the Color';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _isLoading
                            ? Center(
                                child: LoadingAnimationWidget.hexagonDots(
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
                                      (_selectImage != null &&
                                          // ignore: unrelated_type_equality_checks
                                          _selectImage != "")) {
                                    registervalidation(context);
                                  }
                                },
                                child: const Text("Confirm"),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(color: AppColors.primaryColor),
    );
  }
}
