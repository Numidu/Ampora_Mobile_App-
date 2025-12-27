import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _scale = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slide = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, 'screens/Login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/logo.png", width: 130),
                  const SizedBox(height: 22),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.black, Colors.white70],
                    ).createShader(bounds),
                    child: const Text(
                      "AMPORA",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Powering Sri Lanka EV Travel",
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
