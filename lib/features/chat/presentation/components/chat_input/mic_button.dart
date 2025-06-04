import 'package:mahe_chat/app/utils/widgets/my_filled_icon.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../my_snackbar.dart';

class MicButton extends StatelessWidget {
  const MicButton({
    super.key,
    required this.screenSize,
    required this.onStart,
    required this.onRelese,
    required this.onCancel,
    this.onLock,
    required this.isMicWidget,
    required this.showSend,
  });
  final Future<void> Function() onStart;
  final Future<void> Function() onRelese;
  final Future<void> Function() onCancel;
  final void Function()? onLock;
  final Size screenSize;
  final bool isMicWidget;
  final bool showSend;

  Future<bool> _handlePermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      MySnackBar.showMySnackBar("Access denied to mic");
    }
    return status.isGranted;
  }

  void _vibrate() {
    HapticFeedback.heavyImpact();
    // Vibration.vibrate(duration: 10, amplitude: 255);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(
      builder: (context, ref, child) {
        final micRead = ref.read(micProvicer.notifier);
        final micWatch = ref.watch(micProvicer);
        final isLtr = Directionality.of(context) == TextDirection.ltr;
        return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              reverseDuration: const Duration(milliseconds: 150),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return AnimatedContainer(
                  transform:
                      Matrix4.translationValues(micWatch.offset.dx, 0, 0),
                  duration: Durations.short2,
                  width: micWatch.isMicPressed || isMicWidget ? 70 : 46,
                  height: micWatch.isMicPressed || isMicWidget ? 70 : 46,
                  child: FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  ),
                );
              },
              child: !showSend
                  ? GestureDetector(
                      onTap: onRelese,
                      child: MyFilledIcon(
                        icon: Icons.send,
                        size: 26,
                        fillColor: theme.colorScheme.inversePrimary,
                        color: Colors.black,
                      ),
                    )
                  : GestureDetector(
                      onPanStart: (details) async {
                        final permission = await _handlePermission();
                        if (!micWatch.isMicPressed && permission) {
                          _vibrate();
                          micRead.change(isMicPressed: true);
                          onStart();
                        }
                      },
                      onPanUpdate: (details) async {
                        if (micWatch.isMicPressed) {
                          if (isLtr) {
                            micRead.change(
                                offset: Offset(
                                    details.localPosition.dx.clamp(-800, 0),
                                    details.localPosition.dy.clamp(-800, 0)));
                          } else {
                            micRead.change(
                                offset: Offset(
                                    details.localPosition.dx.clamp(0, 800),
                                    details.localPosition.dy.clamp(-800, 0)));
                          }
                        }
                        if (micWatch.offset.dy < -150) {
                          _vibrate();
                          micRead.change(
                              isMicPressed: false, offset: Offset.zero);
                          onLock?.call();
                        } else if (isLtr) {
                          if (micWatch.offset.dx <
                              -(screenSize.width / 2) + 46) {
                            _vibrate();
                            micRead.reset();
                            onCancel.call();
                          }
                        } else {
                          if (micWatch.offset.dx >
                              (screenSize.width / 2) - 46) {
                            onCancel();
                            _vibrate();
                            micRead.change(
                                isMicPressed: false, offset: Offset.zero);
                          }
                        }
                      },
                      onPanEnd: (details) async {
                        if (micWatch.isMicPressed) {
                          onRelese();
                          _vibrate();
                          micRead.change(
                              isMicPressed: false, offset: Offset.zero);
                        }
                      },
                      onTapDown: (details) async {
                        final permission = await _handlePermission();
                        if (permission) {
                          if (!micWatch.isMicPressed) {
                            _vibrate();
                            micRead.change(isMicPressed: true);
                            onStart();
                          }
                        }
                      },
                      onTapUp: (d) async {
                        onRelese();
                        _vibrate();
                        micRead.reset();
                      },
                      child: MyFilledIcon(
                        icon: Icons.mic,
                        size: 26,
                        fillColor: theme.colorScheme.inversePrimary,
                        color: Colors.black,
                      ),
                    ),
            ),
            if (micWatch.isMicPressed)
              AnimatedContainer(
                duration: Durations.long4,
                transformAlignment: Alignment.center,
                transform: Matrix4.translationValues(
                    isLtr ? 10 : -10, -100 + (micWatch.offset.dy / 4), 0)
                  ..rotateZ(45 + (micWatch.offset.dy / 150)),
                child: MyFilledIcon(
                  fillColor: theme.primaryColor,
                  size: calculateProgress(micWatch.offset.dy),
                  icon: Icons.lock,
                ),
              ),
          ],
        );
      },
    );
  }

  calculateProgress(double y) {
    return ((y / -150).clamp(0, 1) * 60).clamp(16, 40).toDouble();
  }
}

class MicController {
  final Offset offset;
  final bool isMicPressed;
  MicController({this.offset = Offset.zero, this.isMicPressed = false});
}
