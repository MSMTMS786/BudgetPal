import 'package:flutter/material.dart';

class AnimatedFAB extends StatefulWidget {
  final Function() onPressed;
  
  const AnimatedFAB({Key? key, required this.onPressed}) : super(key: key);

  @override
  _AnimatedFABState createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  int _colorIndex = 0;
  
  final List<Color> _colors = [
    const Color(0xFFFFD700), // Gold
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.orange,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _colors.length;
          _updateColorAnimation();
        });
        _controller.forward(from: 0.0);
      }
    });
    
    _updateColorAnimation();
    _controller.forward();
  }
  
  void _updateColorAnimation() {
    _colorAnimation = ColorTween(
      begin: _colors[_colorIndex],
      end: _colors[(_colorIndex + 1) % _colors.length],
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: _colorAnimation.value,
          child: const Icon(Icons.add, color: Colors.white),
        );
      },
    );
  }
}