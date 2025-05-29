import 'dart:io';

import 'package:chatme/constant/const.dart';
import 'package:chatme/view/src/db/db.dart';
// import 'package:chatme/view/src/pages/pratice_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:chatme/theme/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  bool _isLoading = false;
  // ignore: non_constant_identifier_names
  Map<String, String>? product_id;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _color = TextEditingController();
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  bool _formSubmitted = false;
  File? _selectImage;
  ProductModel? product;

  @override
  void initState() {
    initaialfun();

    super.initState();
  }

  Future<void> downloadImageToFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/temp_image.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _selectImage = file;
        });
      } else {
        // ignore: avoid_print
        print('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to download image: $e');
    }
  }

  void fetchData() async {
    product_id = await Db.getProductData();
    var url = Uri.parse(
        "${Constants.url}/shop_product.php?product_id=${product_id!['product_id']}");

    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      setState(() {
        product = ProductModel.fromJson(decoded['data']);
      });
    } else {
      // ignore: avoid_print
      print('Failed to get product: ${response.body}');
    }
    if (product != null) {
      _name.text = product!.name;
      _rate.text = product!.rate;
      _color.text = product!.color;

      final imagePath = product!.image;
      final fullImageUrl = imagePath.startsWith('http')
          ? imagePath
          : '${Constants.url}/$imagePath';

      await downloadImageToFile(fullImageUrl);
    }
  }

  void initaialfun() {
    fetchData();
  }

  Future<String?> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> updatevalidation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_selectImage != null) {
      // Get local app directory
      final appDir = await getApplicationDocumentsDirectory();

      // Create 'product_image' folder
      final productImageDir = Directory('${appDir.path}/product_image');
      if (!(await productImageDir.exists())) {
        await productImageDir.create(recursive: true);
      }

      // Copy image into 'product_image' folder
      basename(_selectImage!.path);

      // Optional: Delete the temp file
    }
    String? base64Image;
    if (_selectImage != null) {
      base64Image = await convertImageToBase64(_selectImage!);
    }
    var url = Uri.parse('${Constants.url}/shop_product.php');

    Map<String, dynamic> product = {
      "edit": true,
      "product_id": product_id!['product_id'],
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

    if (await _selectImage!.exists()) {
      await _selectImage!.delete();
    }
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

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
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
                        "Update Product",
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
                          controller: _rate,
                          decoration: const InputDecoration(
                            label: Text("rate"),
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
                              return 'Enter the rate';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              child: const Row(
                                children: [
                                  Text("Image"),
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
                                'Please select Product Image.',
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
    );
  }
}
