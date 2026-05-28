import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ParticleBackground extends StatefulWidget {
  final bool isDarkMode;

  const ParticleBackground({super.key, required this.isDarkMode});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  final int _particleCount = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles with random values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.sizeOf(context);
      for (int i = 0; i < _particleCount; i++) {
        _particles.add(Particle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          size: _random.nextDouble() * 4 + 2,
          speedX: (_random.nextDouble() - 0.5) * 0.4,
          speedY: (_random.nextDouble() - 0.5) * 0.4,
          opacity: _random.nextDouble() * 0.3 + 0.1,
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDarkMode
        ? AppConstants.darkAccentColor
        : AppConstants.lightAccentColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);
        // Update particle positions
        for (var particle in _particles) {
          particle.update(size.width, size.height);
        }

        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(
            particles: _particles,
            particleColor: color,
          ),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  void update(double width, double height) {
    x += speedX;
    y += speedY;

    // Wrap around boundaries
    if (x < 0) {
      x = width;
    } else if (x > width) {
      x = 0;
    }

    if (y < 0) {
      y = height;
    } else if (y > height) {
      y = 0;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color particleColor;

  ParticlePainter({
    required this.particles,
    required this.particleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particleColor.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2); // Glowing edge

      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
