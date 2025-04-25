import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MySwipe extends StatefulWidget {
  const MySwipe({
    Key? key,
    required this.child,
    required this.isMine,
    this.onSwipe,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final bool isMine;
  final void Function()? onSwipe;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  State<MySwipe> createState() => _MySwipeState();
}

class _MySwipeState extends State<MySwipe> {
  double _position = 0;
  int _duration = 0;
  bool canVibrate = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onHorizontalDragUpdate: (details) async {
        _duration = 0;
        _position += details.primaryDelta!;
        if (_position < 0) {
          _position = 0;
        } else if (_position > 80) {
          _position = 80;
        } else if (_position > 60) {
          if (canVibrate) {
            HapticFeedback.heavyImpact();
            canVibrate = false;
          }
        } else if (_position < 55 && details.primaryDelta! < 0 && !canVibrate) {
          canVibrate = true;
        }
        setState(() {});
      },
      onHorizontalDragEnd: (details) {
        _duration = 200;
        canVibrate = true;
        if (_position > 60) {
          widget.onSwipe?.call();
        }
        setState(() {
          _position = 0;
        });
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.centerRight,
          fit: StackFit.passthrough,
          children: [
            AnimatedContainer(
                duration: Duration(milliseconds: _duration),
                transform: Matrix4.translationValues(
                    _position - (MediaQuery.of(context).size.width / 2 + 10),
                    0,
                    0),
                child: Opacity(
                  opacity: calculateOpacity,
                  child: CustomPaint(
                    painter: CircularPainter(_position / 60, 25),
                    child: const Icon(
                      Icons.reply,
                      size: 14,
                    ),
                  ),
                )),
            AnimatedContainer(
              duration: Duration(milliseconds: _duration),
              transform: Matrix4.translationValues(_position, 0, 0),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }

  get calculateOpacity {
    return (_position / 60).clamp(0, 1.0);
  }
}

class CircularPainter extends CustomPainter {
  final double value;
  final double radious;

  CircularPainter(this.value, this.radious);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = radious / 2;
    final progressPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = value >= 1 ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressAngle = 2 * 3.14 * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
