import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class JuiceWidget extends StatelessWidget {
  final Juice juice;
  final double height;

  const JuiceWidget({
    super.key,
    required this.juice,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidLinearProgressIndicator(
      value: height, 
      valueColor: AlwaysStoppedAnimation(juice.color), // Color based on juice 
      direction: Axis.vertical,
      center: Text(
        '${(height * 100).toStringAsFixed(0)}%', 
      ),
    );
  }
}
