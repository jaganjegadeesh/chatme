import 'dart:io';

import 'package:chatme/view/src/auth/login.dart';
import 'package:chatme/view/src/auth/profile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../db/db.dart';
import 'package:chatme/theme/theme.dart';

class PraticePage extends StatefulWidget {
  const PraticePage({super.key});

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
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
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'its Life',
            style: TextStyle(color: Colors.purpleAccent),
          ),
          actions: [
            Builder(
              builder: (context) => TextButton(
                onLongPress: () {
                  Scaffold.of(
                    context,
                  ).openEndDrawer(); // ✅ This now works safely
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
                child: _profile != null
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
                          width: 40,
                          height: 40,
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
        endDrawer: Container(
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 138, 221, 241),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "asset/images/zoro.jpg",
                        height: 50,
                        width: 50,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Menu', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              ListTile(title: const Text('Item 1'), onTap: () {}),
              ListTile(title: const Text('Item 2'), onTap: () {}),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Good Morning,",
              style: TextStyle(color: Colors.black45, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "dear $name",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.waving_hand_rounded),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("asset/images/troffy.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor:
                            Colors.yellowAccent, // Optional: Removes shadow
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Top 25",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Keep it up",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // Make sure text is readable on the image
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black45,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "2 week of strick reporting",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors
                            .white, // Make sure text is readable on the image
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black45,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Popular reports",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(width: 4), // small spacing between text and icon
                      Icon(
                        Icons.electric_bolt,
                        color: Color.fromARGB(255, 53, 53, 3),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.black,
                        ), // fixed casing and color
                        SizedBox(width: 4),
                        Text("Info", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enlargeCenterPage: true,
                viewportFraction: 0.6,
                enableInfiniteScroll: true,
                autoPlay: false,
              ),
              items: [
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("asset/images/women.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.topLeft,
                  child: const Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "women Abuse",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Sexually, Physically, Emotionally",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors
                                .white, // Make sure text is readable on the image
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("asset/images/child.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.topLeft,
                  child: const Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Child Abuse",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Sexually, Physically, Emotionally",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("asset/images/men.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.topLeft,
                  child: const Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Men Abuse",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Make sure text is readable on the image
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Sexually, Physically, Emotionally",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors
                                .white, // Make sure text is readable on the image
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Popular reports",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(width: 4), // small spacing between text and icon
                      Icon(
                        Icons.electric_bolt,
                        color: Color.fromARGB(255, 53, 53, 3),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.black,
                        ), // fixed casing and color
                        SizedBox(width: 4),
                        Text("Info", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListBody(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 238, 230, 230),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "asset/images/animal.jpg",
                        height: 50,
                        width: 50,
                      ),
                      const Column(
                        children: [
                          Text(
                            "Animal Abuse",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Sexually, Physically, Emotionally",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_right),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 238, 230, 230),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "asset/images/animal.jpg",
                        height: 50,
                        width: 50,
                      ),
                      const Column(
                        children: [
                          Text(
                            "Animal Abuse",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Sexually, Physically, Emotionally",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_right),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 238, 230, 230),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "asset/images/animal.jpg",
                        height: 50,
                        width: 50,
                      ),
                      const Column(
                        children: [
                          Text(
                            "Animal Abuse",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Sexually, Physically, Emotionally",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
