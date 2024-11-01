import 'package:flutter/material.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'dart:math'; 
import 'package:juice_drinker/widgets/fizz.dart';

class JuiceWidget extends StatelessWidget {
  final Juice juice;
  final double height;
  final double rotation;
  final double verticalOffset;

  const JuiceWidget({
    super.key,
    required this.juice,
    required this.height,
    required this.rotation,
    this.verticalOffset = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final adjustedVerticalOffset =
        verticalOffset * cos(rotation * (pi / 180));

    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform.translate(
          offset: Offset(0, adjustedVerticalOffset),
          child: Transform.rotate(
            angle: rotation * (pi / 180),
            child: Stack(
              children: [
                OverflowBox(
                  maxWidth: double.infinity,
                  child: SizedBox(
                    width: 1000,
                    child: LiquidLinearProgressIndicator(
                      value: height,
                      valueColor: AlwaysStoppedAnimation(juice.color),
                      direction: Axis.vertical,
                    ),
                  ),
                ),
                if (juice.fizzy)
                  Fizz(
                    height: height,
                    rotation: rotation,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}