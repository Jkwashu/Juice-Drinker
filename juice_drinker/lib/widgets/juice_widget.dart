import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class JuiceWidget extends StatelessWidget {
  final Juice juice;
  final double height;
  final double rotation;

  const JuiceWidget({
    super.key,
    required this.juice,
    required this.height,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * (3.14159 / 180), // Convert degrees to radians
      child: LiquidLinearProgressIndicator(
        value: height, 
        valueColor: AlwaysStoppedAnimation(juice.color),
        direction: Axis.vertical,
        center: Text(
          '${(height * 100).toStringAsFixed(0)}%', 
        ),
      ),
    );
  }
}