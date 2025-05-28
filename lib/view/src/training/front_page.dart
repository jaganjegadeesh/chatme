import 'package:flutter/material.dart';
import '../auth/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    void goToLogin(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 400,
            width: 400,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 18, 19, 19),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                bottomRight: Radius.circular(150),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 246, 250, 250),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 250, 250),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "asset/images/animal.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Company",
              style: TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Text(
            "A platform biult for a new way of working",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () => goToLogin(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_forward_ios_rounded),
                  SizedBox(width: 8),
                  Text("Go To Login"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
