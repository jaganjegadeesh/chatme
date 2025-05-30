import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatme/constant/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  void _generateAndPreviewPdf(
      Map<String, dynamic> order, List<dynamic> products) {
    final pdf = pw.Document();

    double totalAmount = 0;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Order ID: ${order['id']}",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text("Name: ${order['name']}"),
              pw.Text("Phone: ${order['phone']}"),
              pw.Text("Address: ${order['address']}"),
              pw.SizedBox(height: 16),
              pw.Text("Products:",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: const pw.FixedColumnWidth(40),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FixedColumnWidth(50),
                  3: const pw.FixedColumnWidth(70),
                  4: const pw.FixedColumnWidth(80),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("S.No",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Product",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Qty",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Rate",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Amount",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),

                  // Body rows
                  ...List.generate(products.length, (index) {
                    final product = products[index];
                    final quantity =
                        int.tryParse(product['quantity'].toString()) ?? 1;
                    final rate =
                        double.tryParse(product['rate'].toString()) ?? 0.0;
                    final amount = quantity * rate;
                    totalAmount += amount;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("${index + 1}"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(product['name']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("$quantity"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Rs. ${rate.toStringAsFixed(2)}"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Rs. ${amount.toStringAsFixed(2)}"),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text("Total: ",
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text("Rs. ${totalAmount.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green)),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Show PDF preview
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID: ${order['id']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.file_download),
                            onPressed: () {
                              final products =
                                  order['products'] as List<dynamic>;
                              _generateAndPreviewPdf(order, products);
                            },
                          )
                        ],
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
                                    "Rate: Rs. ${rate.toStringAsFixed(2)} x $quantity = Rs. ${amount.toStringAsFixed(2)}"),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total Amount: Rs. ${totalAmount.toStringAsFixed(2)}",
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
