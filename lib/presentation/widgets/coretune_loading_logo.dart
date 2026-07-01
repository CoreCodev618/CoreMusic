import 'package:flutter/material.dart';

/// Versión blanca y animada del logo de CoreTune: aro giratorio +
/// barras de audio pulsando. Pensado para fondos oscuros (poco contraste).
class CoreTuneLoadingLogo extends StatefulWidget {
  final double size;

  const CoreTuneLoadingLogo({super.key, this.size = 120});

  @override
  State<CoreTuneLoadingLogo> createState() => _CoreTuneLoadingLogoState();
}

class _CoreTuneLoadingLogoState extends State<CoreTuneLoadingLogo>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _rotateController,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _RingPainter(),
            ),
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.size * 0.55, widget.size * 0.55),
                painter: _BarsPainter(t: _pulseController.value),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      size.width * 0.07,
      size.height * 0.07,
      size.width * 0.86,
      size.height * 0.86,
    );

    // Arco incompleto (estilo "C" del logo) para sugerir movimiento.
    canvas.drawArc(rect, -1.6, 4.9, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarsPainter extends CustomPainter {
  final double t;

  _BarsPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final h1 = size.height * (0.35 + 0.4 * t);
    final h2 = size.height * (0.5 + 0.35 * (1 - t));
    final r = size.width * 0.08;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.32, size.height / 2),
          width: size.width * 0.16,
          height: h1,
        ),
        Radius.circular(r),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.55, size.height / 2),
          width: size.width * 0.16,
          height: h2,
        ),
        Radius.circular(r),
      ),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.78, size.height / 2),
      size.width * 0.085,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BarsPainter oldDelegate) => oldDelegate.t != t;
}
