import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';

class ShopPage extends StatelessWidget {
  final Function(Juice) onJuiceUpdate;
  final int coins;

  const ShopPage({Key? key, required this.onJuiceUpdate, required this.coins})
      : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _currentIndex = 0;
  List<Juice> _juices = [
    Juice(color: Colors.orange, name: 'Orange Juice', price: 20),
    Juice(color: Colors.purple, name: 'Grape Juice', price: 20),
    Juice(color: Colors.red, name: 'Cranberry Juice', price: 20),
    Juice(color: Colors.blue, name: 'Blueberry Juice', price: 20),
    Juice(color: Colors.green, name: 'Grapefruit Juice', price: 20),
  ];

  void _nextJuice() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _juices.length;
    });
  }

  void _previousJuice() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _juices.length) % _juices.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juice Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on),
                const SizedBox(width: 4),
                Text('${widget.coins}'),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _previousJuice,
              ),
              Container(
                width: 200,
                height: 200,
                color: _juices[_currentIndex].color,
                child: Center(
                  child: Text(
                    _juices[_currentIndex].name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _nextJuice,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement purchase logic
            },
            child: Text('Buy for ${_juices[_currentIndex].price} coins'),
          ),
        ],
      ),
    );
  }
}
