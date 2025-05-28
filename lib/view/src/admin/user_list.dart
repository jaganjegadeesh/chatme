import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          firebase
              .collection('users')
              .where('role', isEqualTo: "user")
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 4.0,
              ),
              child: Card(
                child: ListTile(
                  onTap: () {
                    debugPrint(data['name']);
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'] ?? ''),
                      Text(data['email'] ?? ''),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage:
                        data['imageUrl'] != null
                            ? FileImage(File(data['imageUrl']))
                            : const AssetImage('asset/images/zoro.jpg')
                                as ImageProvider,
                  ),
                  trailing: const Icon(Icons.play_arrow_rounded),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
