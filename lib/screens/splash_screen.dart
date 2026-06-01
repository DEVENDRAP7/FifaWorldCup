import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;   // logo fade-in
  late final Animation<double> _scale;  // subtle scale-in
  late final Animation<double> _shine;  // shine sweep across logo

  static const double _logo = 150;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _fade = CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.45, curve: Curves.easeOut));
    _scale = Tween(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack)),
    );
    // Shine sweeps twice for a clear glint.
    _shine = CurvedAnimation(parent: _c, curve: const Interval(0.30, 1.0, curve: Curves.easeInOut));

    _c.forward();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, a, _) => FadeTransition(opacity: a, child: const HomeScreen()),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B1330),
            Color(0xFF3A1F35),
            Color(0xFF7A2E2A),
            Color(0xFFC8542B),
            Color(0xFFE89647),
            Color(0xFFEBB46D),
          ],
          stops: [0.0, 0.22, 0.45, 0.68, 0.85, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.40),
                      blurRadius: 36,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: _logo,
                  height: _logo,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned.fill(child: Image.asset('assets/icon.png', fit: BoxFit.cover)),
                        // diagonal shine band — clipped to the logo bounds
                        AnimatedBuilder(
                          animation: _shine,
                          builder: (context, _) {
                            final t = (_shine.value * 1.6) % 1.0; // ~2 passes
                            final left = (t * 1.9 - 0.55) * _logo; // sweep across
                            return Positioned(
                              top: -_logo * 0.5,
                              bottom: -_logo * 0.5,
                              left: left,
                              width: _logo * 0.42,
                              child: Transform.rotate(
                                angle: -0.45,
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0x00FFFFFF),
                                        Color(0x73FFFFFF),
                                        Color(0x00FFFFFF),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
