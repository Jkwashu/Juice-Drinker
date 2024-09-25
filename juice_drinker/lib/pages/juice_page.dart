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

    // Subscribe to magnetometer events
    _magnetometerSubscription = magnetometerEvents.listen(
      (MagnetometerEvent event) {
        setState(() {
          _magnetometerEvent = event;
          _updateYaw(); // Update yaw when new magnetometer data is available
          print(_yawDegrees);
        });
      },
    );

    // Subscribe to accelerometer events
    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        setState(() {
          _accelerometerEvent = event;
          _updateYaw(); // Update yaw when new accelerometer data is available
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

  // Method to update yaw
void _updateYaw() {
  if (_magnetometerEvent == null || _accelerometerEvent == null) {
    return; // Wait until both sensor readings are available
  }

  // Get accelerometer readings
  double accelX = _accelerometerEvent!.x;
  double accelY = _accelerometerEvent!.y;
  double accelZ = _accelerometerEvent!.z;

  // Compute roll (phi) and pitch (theta)
  double phi = atan2(accelY, accelZ);
  double theta = atan2(-accelX, sqrt(accelY * accelY + accelZ * accelZ));

  // Get magnetometer readings
  double magX = _magnetometerEvent!.x;
  double magY = _magnetometerEvent!.y;
  double magZ = _magnetometerEvent!.z;

  // Compensate magnetometer readings
  double magXh = magX * cos(theta) + magZ * sin(theta);
  double magYh = magX * sin(phi) * sin(theta) + magY * cos(phi) - magZ * sin(phi) * cos(theta);

  // Compute yaw (psi)
  double psi = atan2(magYh, magXh);

  // Convert to degrees and adjust to standard compass directions
  double yawDegrees = (psi * 180 / pi + 90) % 360;
  
  // Ensure the result is between 0 and 360
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
      ),
    );
  }
}