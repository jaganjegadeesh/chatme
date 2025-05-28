import 'dart:io';
import 'package:chatme/view/src/chat/chat_room.dart';
import 'package:chatme/view/src/db/db.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({super.key});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String? myUserId, myName, myPhoto, myEmail, chatRoomId, messageId;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String getchatRoomIdByUserId(String a, String b) {
    if (a.compareTo(b) > 0) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    dynamic userData = await Db.getData();
    myUserId = userData['userId'];
    myName = userData['name'];
    myEmail = userData['email'];
    myPhoto = userData['imageUrl'];
    // print("$myUserId %% $myName %% $myEmail %% $myPhoto");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search by name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firebase
                .collection('users')
                .where('role', isEqualTo: "user")
                .where('userId', isNotEqualTo: myUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];

              // Filter users by search query
              final filteredDocs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name = (data['name'] ?? '').toLowerCase();
                return name.contains(searchQuery);
              }).toList();

              return ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final data =
                      filteredDocs[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 4.0,
                    ),
                    child: Card(
                      child: ListTile(
                        onTap: () async {
                          var chatRoomId =
                              getchatRoomIdByUserId(myUserId!, data['userId']);
                          Map<String, dynamic> chatInfoMap = {
                            "users": [myUserId, data['userId']],
                          };
                          await Db().createChatRoom(chatRoomId, chatInfoMap);
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                sendUserId: data['userId'],
                                sendName: data['name'],
                                sendPic: data['imageUrl'],
                              ),
                            ),
                          );
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'] ?? ''),
                            Text(data['email'] ?? ''),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundImage: data['imageUrl'] != null
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
          ),
        ),
      ],
    );
  }
}
