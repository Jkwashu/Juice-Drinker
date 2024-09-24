import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class JuicePage extends StatefulWidget {
  const JuicePage({super.key});

  @override
  _JuicePageState createState() => _JuicePageState();
}

class _JuicePageState extends State<JuicePage> {
  double _drinkHeight = .8; // DRINK HEIGHT

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LiquidLinearProgressIndicator(
                value: _drinkHeight,
                valueColor: const AlwaysStoppedAnimation(Color.fromARGB(255, 42, 196, 210)),
                direction: Axis.vertical,
                center: Text(
                  '${(_drinkHeight * 100)}%'
                ),
              ),
    );
  }
}
