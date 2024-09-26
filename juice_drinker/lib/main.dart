import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:juice_drinker/pages/juice_page.dart';
import 'package:juice_drinker/pages/shop_page.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juice Drinker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 124, 207, 216)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Juice _currentJuice = Juice(color: const Color.fromARGB(255, 20, 251, 255), name: 'Water'); // INITIAL JUICE

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to update the current juice (use this in ShopPage later)
  void _updateJuice(Juice newJuice) {
    setState(() {
      _currentJuice = newJuice;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pass the current juice to JuicePage and update method to ShopPage
    final List<Widget> pages = <Widget>[
      JuicePage(juice: _currentJuice),
      ShopPage(), // Passing update function
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink, size: 32),
            label: 'Juice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined, size: 32),
            label: 'Shop',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

