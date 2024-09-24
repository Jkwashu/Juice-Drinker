import 'package:flutter/material.dart';
import 'package:juice_drinker/widgets/juice_widget.dart';
import 'package:juice_drinker/objects/juice.dart';

class JuicePage extends StatelessWidget {
  final Juice juice;

  const JuicePage({super.key, required this.juice});

  @override
  Widget build(BuildContext context) {
    double drinkHeight = 1.0;  // NEEDS TO BE BETWEEN 0 AND 1

    return Center(
      child: JuiceWidget(
        juice: juice,
        height: drinkHeight,
      ),
    );
  }
}
