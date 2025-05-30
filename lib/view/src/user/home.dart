import 'dart:io';

import 'package:chatme/view/src/admin/user_list.dart';
// import 'package:chatme/view/src/admin/video_player.dart';
import 'package:chatme/view/src/auth/login.dart';
import 'package:chatme/view/src/auth/profile.dart';
import 'package:chatme/view/src/chat/chat_user.dart';
import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
import '../db/db.dart';
import 'package:chatme/theme/theme.dart';

class Userhome extends StatefulWidget {
  const Userhome({super.key});

  @override
  State<Userhome> createState() => _UserhomeState();
}

class _UserhomeState extends State<Userhome> {
  String? _bodywidget = 'userhome';
  String? name;
  File? _profile;

  @override
  void initState() {
    initaialfun();

    super.initState();
  }

  void fetchData() async {
    Map<String, String>? user = await Db.getData();
    if (user != null) {
      setState(() {
        name = user['name'] ?? 'No name';
        if (user['imageUrl'] != null) {
          final tempImage = File(user['imageUrl']!);
          _profile = tempImage;
        }
      });
    }
  }

  void initaialfun() {
    fetchData();
  }

  void logout() async {
    await Db.clearDb();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  Widget _getBodyWidget() {
    switch (_bodywidget) {
      case 'userhome':
        return const Userhomepage();
      case 'userlist':
        return const UserList();
      case 'Chat':
        return const ChatUser();
      default:
        return const Userhomepage(); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Exit the app if back button is pressed and pop didn't happen
          exit(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.drag_handle_sharp),
                tooltip: 'Menu',
                onPressed: () {
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject()
                          as RenderBox;
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset position = box.localToGlobal(Offset.zero);

                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy + box.size.height,
                      overlay.size.width - position.dx,
                      0,
                    ),
                    items: [
                      const PopupMenuItem(
                        value: 'userhome',
                        child: Row(
                          children: [
                            Icon(Icons.home_outlined, color: Colors.black),
                            SizedBox(width: 10),
                            Text('Home'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Chat',
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervised_user_circle_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text('Chat'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'video',
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervised_user_circle_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text('Video'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'notice',
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text('notice'),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    setState(() {
                      _bodywidget = value;
                    });
                  });
                },
              );
            },
          ),
          centerTitle: true,
          title: const Text('its Life'),
          actions: [
            Builder(
              builder:
                  (context) => TextButton(
                    onLongPress: () {
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox;
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final Offset position = box.localToGlobal(Offset.zero);

                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          position.dx,
                          position.dy + box.size.height,
                          overlay.size.width - position.dx,
                          0,
                        ),
                        items: [
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.power_settings_new,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (value == 'logout') {
                          logout();
                        }
                      });
                    },
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Profile()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                    ),
                    child:
                        _profile != null
                            ? Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(_profile!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            : Padding(
                              padding: EdgeInsets.zero,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                  ),
            ),
          ],
        ),
        endDrawer: Drawer(
          width: 200,
          child: Container(
            decoration: BoxDecoration(color: AppColors.pureWhiteColor),
            child: TextButton(
              onPressed: () {
                logout();
              },
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 20),
                  Text("Logout"),
                ],
              ),
            ),
          ),
        ),
        body: _getBodyWidget(),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home, color: Colors.blueGrey),
                tooltip: 'Home',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.save, color: Colors.blueGrey),
                tooltip: 'Saved',
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.cloud_circle_sharp,
                      color: Color.fromARGB(255, 20, 20, 20),
                    ),
                    tooltip: 'Saved',
                  ),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_sharp, color: Colors.blueGrey),
                tooltip: 'File',
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                icon: const Icon(
                  Icons.person_3_outlined,
                  color: Colors.blueGrey,
                ),
                tooltip: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Userhomepage extends StatefulWidget {
  const Userhomepage({super.key});

  @override
  State<Userhomepage> createState() => _UserhomepageState();
}

class _UserhomepageState extends State<Userhomepage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("User"));
  }
}
