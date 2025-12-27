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

  Widget _loadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            double opacity = (i + _controller.value * 3) % 3 < 1 ? 1 : 0.3;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity,
                child: const CircleAvatar(
                    radius: 4, backgroundColor: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF009daa),
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
                  Image.asset("assets/images/logo.png", width: 130),
                  const SizedBox(height: 22),
                  const Text(
                    "AMPORA",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _loadingDots(), // 🔥 LOADING EFFECT
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
