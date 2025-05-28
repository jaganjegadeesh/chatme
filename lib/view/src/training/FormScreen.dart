import 'package:flutter/material.dart';

class Formscreen extends StatelessWidget {
  Formscreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "Enter Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter The Name";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: "Enter Number"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter The Number";
                } else {
                  return null;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.fork_right_rounded),
              color: Colors.deepOrange,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text("Are You Sure?"),
                      content: const Text("Do you Ok"),
                      elevation: 24.0,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
