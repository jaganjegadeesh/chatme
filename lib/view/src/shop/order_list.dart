import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatme/constant/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<dynamic> _orderList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    getOrderDatas();
  }

  Future<void> getOrderDatas() async {
    final url = Uri.parse("${Constants.url}shop_order.php?getAllOrders=");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] is List) {
          setState(() {
            _orderList = jsonData['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = "Invalid response or empty order list.";
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
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shop Orders",
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
              ],
            ),
          ),
          Center(child: Text(_error!))
        ],
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shop Orders",
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
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _orderList.length,
            itemBuilder: (context, index) {
              final order = _orderList[index];
              final products = order['products'] as List<dynamic>;
              double totalAmount = 0;
              for (var product in products) {
                final rate = double.tryParse(product['rate'].toString()) ?? 0.0;
                final quantity =
                    int.tryParse(product['quantity'].toString()) ?? 1;
                totalAmount += rate * quantity;
              }
              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${order['id']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Name: ${order['name']}"),
                      Text("Phone: ${order['phone']}"),
                      Text("Address: ${order['address']}"),
                      const SizedBox(height: 8),
                      const Text(
                        "Products:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const Divider(),
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, prodIndex) {
                              final product = products[prodIndex];
                              final quantity = int.tryParse(
                                      product['quantity'].toString()) ??
                                  1;
                              final rate =
                                  double.tryParse(product['rate'].toString()) ??
                                      0.0;
                              final amount = quantity * rate;

                              return ListTile(
                                leading: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: CachedNetworkImage(
                                    imageUrl: product['image'] != null
                                        ? '${Constants.url}${product['image']}'
                                        : 'https://via.placeholder.com/70',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(product['name']),
                                subtitle: Text(
                                    "Rate: ₹${rate.toStringAsFixed(2)} x $quantity = ₹${amount.toStringAsFixed(2)}"),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
