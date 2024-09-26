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
  double drinkHeight = 1; 

  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Sensor readings
  MagnetometerEvent? _magnetometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;

  double _yawDegrees = 0.0; // Yaw angle in degrees

  Timer? _drinkTimer;

  // Shake detection variables
  DateTime? _lastShake;
  final _shakeThreshold = 4.0; // Adjust this value to change shake sensitivity
  final _shakeInterval = Duration(milliseconds: 500); // Minimum time between shakes

  bool get isEmpty => drinkHeight <= 0;

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

    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        setState(() {
          _accelerometerEvent = event;
          _updateYaw(); 
        });
      },
    );

    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        setState(() {
          _gyroscopeEvent = event;
          _detectShake();
        });
      },
    );

    // Start a timer to update the drink height
    _drinkTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _updateDrinkHeight();
    });
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _drinkTimer?.cancel();
    super.dispose();
  }

  void _updateYaw() {
    if (_magnetometerEvent == null || _accelerometerEvent == null) {
      return; 
    }

    double accelX = _accelerometerEvent!.x;
    double accelY = _accelerometerEvent!.y;
    double accelZ = _accelerometerEvent!.z;

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

  void _updateDrinkHeight() {
    if (_yawDegrees >= 90 && _yawDegrees <= 270) {
      setState(() {
        // Decrease the height slowly
        drinkHeight = max(0, drinkHeight - 0.005);
      });
    } 
  }

  void _detectShake() {
    if (_gyroscopeEvent == null) return;

    double x = _gyroscopeEvent!.x.abs();
    double y = _gyroscopeEvent!.y.abs();
    double z = _gyroscopeEvent!.z.abs();

    if ((x > _shakeThreshold) ||
        (y > _shakeThreshold) ||
        (z > _shakeThreshold)) {
      
      DateTime now = DateTime.now();
      if (_lastShake == null || now.difference(_lastShake!) > _shakeInterval) {
        _lastShake = now;
        _refillJuice();
      }
    }
  }

  void _refillJuice() {
    setState(() {
      drinkHeight = 1.0; // Refill the juice
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