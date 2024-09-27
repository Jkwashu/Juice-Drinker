import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:juice_drinker/widgets/juice_item_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        title: const Text(
          'Shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow, size: 28),
                const SizedBox(width: 4),
                Text(
                  '${widget.coins}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.allJuices.length,
              itemBuilder: (context, index) {
                final juice = widget.allJuices[index];
                return JuiceItem(
                  juice: juice,
                  isPurchased: widget.purchasedJuices.contains(juice),
                  onPurchase: () {
                    if (widget.coins >= juice.price) {
                      widget.onPurchase(juice);
                      widget.onJuiceUpdate(juice);
                      widget.onCoinUpdate(-juice.price);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Not enough coins or already purchased!'),
                        ),
                      );
                    }
                  },
                  onEquip: () {
                    widget.onJuiceUpdate(juice);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${juice.name} equipped!')),
                    );
                  },
                  coins: widget.coins,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}