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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 124, 207, 216)),
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
  int _coins = 100;
  Juice _currentJuice = Juice(
      color: const Color.fromARGB(255, 33, 150, 243),
      name: 'Water',
      price: 0); // INITIAL JUICE
  List<Juice> _purchasedJuices = [];

  final List<Juice> _allJuices = [
    Juice(color: Colors.orange, name: 'Orange Juice', price: 20),
    Juice(color: Colors.purple, name: 'Grape Juice', price: 20),
    Juice(color: Colors.red, name: 'Cranberry Juice', price: 20),
    Juice(color: Colors.green, name: 'Grapefruit Juice', price: 20),
    Juice(color: const Color.fromARGB(255, 255, 205, 5), name: 'Wheat Juice', price: 30, fizzy: true),
  ];

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

  void _updateCoins(int amount) {
    setState(() {
      _coins += amount;
    });
  }

  void _purchaseJuice(Juice juice) {
    if (!_purchasedJuices.contains(juice)) {
      setState(() {
        _purchasedJuices.add(juice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pass the current juice to JuicePage and update method to ShopPage
    final List<Widget> pages = <Widget>[
      JuicePage(
        juice: _currentJuice,
        onCoinUpdate: _updateCoins,
      ),
      ShopPage(
        onJuiceUpdate: _updateJuice,
        coins: _coins,
        onCoinUpdate: _updateCoins,
        onPurchase: _purchaseJuice,
        purchasedJuices: _purchasedJuices,
        allJuices: _allJuices,
      ), // Passing update function
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_drink,
              size: 32,
              color: Colors.white, // Icon color set to white
            ),
            label: 'Juice',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket_outlined,
              size: 32,
              color: Colors.white, // Icon color set to white
            ),
            label: 'Shop',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Text color set to white
        unselectedItemColor: Colors.white, // Unselected item text color set to white
        onTap: _onItemTapped,
      ),
    );
  }
}