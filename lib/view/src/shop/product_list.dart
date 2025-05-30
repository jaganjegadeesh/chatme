import 'package:chatme/constant/const.dart';
import 'package:http/http.dart' as http;
import 'package:chatme/view/src/db/db.dart';
import 'package:chatme/view/src/shop/add_edit/add_product.dart';
import 'package:chatme/view/src/shop/add_edit/update_product.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> _productList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    getProductDatas();
  }

  Future<void> getProductDatas() async {
    final url = Uri.parse("${Constants.url}shop_product.php?getAllProduct=");
    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      // ignore: avoid_print
      print(response);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] is List) {
          setState(() {
            _productList = jsonData['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = "Invalid response or empty product list.";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Shop Products",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProducts()),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 4),
                      Text("Add", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(child: Text(_error!))
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shop Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProducts()),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 4),
                    Text("Add", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _productList.length,
            itemBuilder: (context, index) {
              final product = _productList[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () async {
                      await Db.setProductId(model: product['product_id']);
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdateProduct()),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product['name'] ?? ''),
                        Text(product['rate'] != null
                            ? '₹${product['rate']}'
                            : ''),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: product['image'] != null
                          ? MemoryImage(base64Decode(product['image']
                              .split(',')
                              .last)) // Remove data prefix if present
                          : const AssetImage('asset/images/zoro.jpg')
                              as ImageProvider,
                    ),
                    trailing: const Icon(Icons.play_arrow_rounded),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
