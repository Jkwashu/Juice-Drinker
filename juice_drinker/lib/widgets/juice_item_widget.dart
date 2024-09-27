import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';

class JuiceItem extends StatelessWidget {
  final Juice juice;
  final bool isPurchased;
  final VoidCallback onPurchase;
  final VoidCallback onEquip;
  final int coins;

  const JuiceItem({
    super.key,
    required this.juice,
    required this.isPurchased,
    required this.onPurchase,
    required this.onEquip,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 400,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: juice.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    juice.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.local_drink,
                      size: 100,
                      color: juice.color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: isPurchased ? onEquip : onPurchase,
                    child: Text(
                      isPurchased
                          ? 'Equip'
                          : 'Buy for ${juice.price} coins',
                      style: const TextStyle(fontSize: 18), 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
