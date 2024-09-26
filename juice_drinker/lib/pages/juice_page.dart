import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:juice_drinker/widgets/juice_widget.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:sensors_plus/sensors_plus.dart';

class JuicePage extends StatefulWidget {
  final Juice juice;
  const JuicePage({super.key, required this.juice});

  @override
  _JuicePageState createState() => _JuicePageState();
}

class _JuicePageState extends State<JuicePage> {
  double drinkHeight = 1.0; 

  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Sensor readings
  MagnetometerEvent? _magnetometerEvent;
  AccelerometerEvent? _accelerometerEvent;

  double _yawDegrees = 0.0; // Yaw angle in degrees

  @override
  void initState() {
    super.initState();

    _magnetometerSubscription = magnetometerEventStream().listen(
      (MagnetometerEvent event) {
        setState(() {
          _magnetometerEvent = event;
          _updateYaw(); 
          
        });
      },
    );

    // Subscribe to accelerometer events
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        setState(() {
          _accelerometerEvent = event;
          _updateYaw(); 
        });
      },
    );
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

void _updateYaw() {
  if (_magnetometerEvent == null || _accelerometerEvent == null) {
    return; 
  }

  double accelX = _accelerometerEvent!.x;
  double accelY = _accelerometerEvent!.y;
  double accelZ = _accelerometerEvent!.z;

  //compute roll (phi) and pitch (theta)
  double phi = atan2(accelY, accelZ);
  double theta = atan2(-accelX, sqrt(accelY * accelY + accelZ * accelZ));

  double magX = _magnetometerEvent!.x;
  double magY = _magnetometerEvent!.y;
  double magZ = _magnetometerEvent!.z;

  double magXh = magX * cos(theta) + magZ * sin(theta);
  double magYh = magX * sin(phi) * sin(theta) + magY * cos(phi) - magZ * sin(phi) * cos(theta);

  double yawRad = atan2(magYh, magXh);
  yawRad -= pi/2;
  yawRad *= -1;
  double yawDegrees = (yawRad * 180 / pi);
  if (yawDegrees < 0) yawDegrees += 360;
  
  setState(() {
    _yawDegrees = yawDegrees;
  });
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: JuiceWidget(
        juice: widget.juice,
        height: drinkHeight,
        rotation: _yawDegrees
      ),
    );
  }
}