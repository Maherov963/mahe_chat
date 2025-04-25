import 'package:flutter/material.dart';

class MyRouter {
  static Future<T> myPush<T>(BuildContext context, Widget child) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        barrierColor: Colors.black.withOpacity(0.3),
        opaque: false,
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
        pageBuilder: (context, animation, secondaryAnimation) => child,
      ),
    );
  }

  static Future<T> myPushReplacment<T>(
      BuildContext context, Widget child) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => child,
      ),
    );
  }

  static Future<T> myPushReplacmentAll<T>(
      BuildContext context, Widget child) async {
    return await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => child,
      ),
      (route) => false,
    );
  }
}
