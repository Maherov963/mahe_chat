import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'login_form.dart';
import 'signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
    if (isLogin) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade900.withOpacity(0.8),
                  const Color(0xFF121212),
                ],
                stops: const [0.0, 0.6],
              ),
            ),
          ),
          // Animated logo and form
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                // Logo with animation
                Image.asset(
                  'assets/images/logo.png', // Use white logo for dark mode
                  height: 120,
                ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

                const SizedBox(height: 40),

                // Form container with dark card
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: isLogin
                      ? LoginForm(toggleAuthMode: toggleAuthMode)
                      : SignupForm(toggleAuthMode: toggleAuthMode),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),

                // Footer text
                Text(
                  isLogin ? 'New to MaheChat?' : 'Already have an account?',
                  style: TextStyle(color: Colors.grey.shade400),
                ).animate().fadeIn(delay: 300.ms),

                TextButton(
                  onPressed: toggleAuthMode,
                  child: Text(
                    isLogin ? 'Create Account' : 'Sign In',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
