// import 'package:chatme/view/src/notification.dart/api.dart';
import 'package:chatme/view/src/user/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatme/firebase_options.dart';
import 'package:chatme/theme/theme.dart';
import 'package:chatme/view/src/admin/home.dart';
import 'package:chatme/view/src/auth/login.dart';
import 'package:chatme/view/src/db/db.dart';
// import 'package:chatme/view/src/pages/pratice_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat Me App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  bool _login = false;
  bool _loading = true;
  UserModel? user;
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String? role = "user";

  @override
  void initState() {
    super.initState();
    initaialfun();
  }

  void fetchData() async {
    _login = await Db.checkLogin();

    if (_login == true) {
      dynamic userData = await Db.getData();
      var doc = await firebase.collection('users').doc(userData?['id']).get();

      if (doc.exists) {
        user = UserModel.fromJson(doc.data()!);
      }
      setState(() {
        role = user?.role;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  void initaialfun() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: _loading
          ? Scaffold(
              body: Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: const Color.fromARGB(255, 252, 75, 75),
                  size: 60,
                ),
              ),
            )
          : _login
              ? role == "user"
                  ? const Userhome()
                  : const Adminhome()
              : const Login(),
    );
  }
}
