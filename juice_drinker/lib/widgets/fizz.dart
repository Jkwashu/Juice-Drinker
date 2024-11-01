import 'dart:math' as math;
import 'package:flutter/material.dart';

class Bubble {
  double x;
  double y;
  double size;
  double speed;
  double wobble;
  double opacity;
  
  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.wobble,
    required this.opacity,
  });
}

class Fizz extends StatefulWidget {
  final double height;
  final double rotation;
  
  const Fizz({
    super.key,
    required this.height,
    required this.rotation,
  });

  @override
  State<Fizz> createState() => _FizzState();
}

class _FizzState extends State<Fizz>
    with TickerProviderStateMixin {
  final List<Bubble> bubbles = [];
  late AnimationController _animationController;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(_updateBubbles);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateBubbles() {
    if (random.nextDouble() < 0.1 && bubbles.length < 20) {
      // Add new bubble
      bubbles.add(Bubble(
        x: random.nextDouble() * 0.8 + 0.1, // Keep within container
        y: 0.1, // Start near bottom
        size: random.nextDouble() * 6 + 4, // Size between 4-10
        speed: random.nextDouble() * 0.01 + 0.005,
        wobble: random.nextDouble() * 0.02 - 0.01,
        opacity: 1.0,
      ));
    }

    setState(() {
      // Update existing bubbles
      for (int i = bubbles.length - 1; i >= 0; i--) {
        final bubble = bubbles[i];
        bubble.y += bubble.speed;
        bubble.x += math.sin(bubble.y * 10) * bubble.wobble;
        
        // Adjust for drink level
        if (bubble.y > widget.height) {
          bubble.opacity -= 0.1;
          if (bubble.opacity <= 0) {
            bubbles.removeAt(i);
            continue;
          }
        }
        
        // Remove if outside container
        if (bubble.y > 1.0 || bubble.x < 0 || bubble.x > 1.0) {
          bubbles.removeAt(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform.rotate(
          angle: widget.rotation * (math.pi / 180),
          child: Stack(
            children: bubbles.map((bubble) {
              return Positioned(
                left: bubble.x * constraints.maxWidth,
                bottom: bubble.y * constraints.maxHeight,
                child: Transform.rotate(
                  angle: -widget.rotation * (math.pi / 180),
                  child: Container(
                    width: bubble.size,
                    height: bubble.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(bubble.opacity * 0.6),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}