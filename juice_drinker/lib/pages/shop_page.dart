import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';

class ShopPage extends StatefulWidget {
  final Function(Juice) onJuiceUpdate;
  final Function(int) onCoinUpdate;
  final Function(Juice) onPurchase;
  final int coins;
  final List<Juice> purchasedJuices;
  final List<Juice> allJuices;

  const ShopPage({
    Key? key,
    required this.onJuiceUpdate,
    required this.coins,
    required this.onCoinUpdate,
    required this.onPurchase,
    required this.purchasedJuices,
    required this.allJuices,
  }) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _currentIndex = 0;

  void _purchaseJuice() {
    if (widget.coins >= widget.allJuices[_currentIndex].price &&
        !widget.purchasedJuices.contains(widget.allJuices[_currentIndex])) {
      setState(() {
        widget.onPurchase(widget.allJuices[_currentIndex]);
        widget.onJuiceUpdate(widget.allJuices[_currentIndex]);
        widget.onCoinUpdate(-widget.allJuices[_currentIndex].price);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins or already purchased!')),
      );
    }
  }

  void _equipJuice() {
    widget.onJuiceUpdate(widget.allJuices[_currentIndex]);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${widget.allJuices[_currentIndex].name} equipped!')),
    );
  }

  void _nextJuice() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.allJuices.length;
    });
  }

  void _previousJuice() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.allJuices.length) %
          widget.allJuices.length;
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
                color: widget.allJuices[_currentIndex].color,
                child: Center(
                  child: Text(
                    widget.allJuices[_currentIndex].name,
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
            onPressed:
                widget.purchasedJuices.contains(widget.allJuices[_currentIndex])
                    ? _equipJuice
                    : _purchaseJuice,
            child: Text(
                widget.purchasedJuices.contains(widget.allJuices[_currentIndex])
                    ? 'Equip'
                    : 'Buy for ${widget.allJuices[_currentIndex].price} coins'),
          ),
        ],
      ),
    );
  }
}
