import 'package:flutter/material.dart';

class Juice {
  final Color color;
  final String name;
  final int price;
  bool purchased;

  Juice({
    required this.color,
    required this.name,
    required this.price,
    this.purchased = false,
  });
}
