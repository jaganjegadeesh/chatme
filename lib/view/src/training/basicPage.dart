import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Basicpage extends StatelessWidget {
  const Basicpage({super.key});

  @override
  Widget build(BuildContext context) {
    File file = File("/storage/emulated/0/DCIM/Camera/IMG_20250317_180453.jpg");

    void displaypin() async {
      final url = Uri.parse("https://api.postalpincode.in/pincode/626123");
      final response = await http.get(url);
      final data = json.decode(response.body);
      final district = data[0]['PostOffice'][0]['District'];
      return showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Pincode is 626123"),
          content: Text("District: $district"),
          elevation: 24.0,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SelectableText(
            "You can Select Me ..!",
            style: TextStyle(color: Colors.redAccent),
          ),
          const Divider(color: Colors.black87, height: 4),
          Image.asset("asset/images/zoro.jpg", height: 50, width: 50),
          Image.network(
            height: 50,
            width: 50,
            "https://images.pexels.com/photos/4041160/pexels-photo-4041160.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          ),
          Image.file(file),
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: const Text('Button 1'),
                onPressed: () => displaypin(),
              ),
              TextButton(child: const Text('Button 2'), onPressed: () {}),
              TextButton(child: const Text('Button 3'), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
