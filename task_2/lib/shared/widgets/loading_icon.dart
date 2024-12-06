import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RefreshIcon extends StatefulWidget {
  final Function onPressed;
  const RefreshIcon({super.key, required this.onPressed});

  @override
  State<RefreshIcon> createState() => _RefreshIconState();
}

class _RefreshIconState extends State<RefreshIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startRotation() async {
    _controller.repeat();
    await widget.onPressed();
    _controller.stop(canceled: false);
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: IconButton(
        icon: const Icon(
          FontAwesomeIcons.arrowsRotate,
          color: Colors.white,
        ),
        onPressed: _startRotation,
        tooltip: "Atualizar",
      ),
    );
  }
}
