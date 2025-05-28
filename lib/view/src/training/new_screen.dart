import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../pages/pratice_view.dart';
import 'front_page.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  void goToPraticeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PraticePage()),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(title: const Text('Next page')),
                      body: const Center(
                        child: Text(
                          'This is the next page',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const GridPaper(
            child: Center(
              child: badges.Badge(
                badgeContent: Text(
                  'Hello jagan',
                  style: TextStyle(color: Colors.white),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300, // Set a fixed height for GridView inside ListView
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: List.generate(
                10,
                (index) => TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black12,
                    backgroundColor: Colors.grey[200],
                  ),
                  child: Text('Button ${index + 1}'),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => goToPraticeScreen(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_ios_rounded),
                SizedBox(width: 8),
                Text("Go To Pratice"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => goToHome(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_ios_rounded),
                SizedBox(width: 8),
                Text("Go To Home"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
