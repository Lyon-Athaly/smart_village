import 'package:flutter/material.dart';

import '../widgets/village_painter.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Smart Village',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17345A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Temukan fasilitas kesehatan terdekat '
                'dengan mudah dan cepat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF75869C)),
              ),
              const SizedBox(height: 32),
              const Expanded(
                flex: 3,
                child: SizedBox(
                  width: double.infinity,
                  child: CustomPaint(painter: VillagePainter()),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  child: const Text('Mulai Sekarang'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
