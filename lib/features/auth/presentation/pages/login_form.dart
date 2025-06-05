import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD
=======
<<<<<<< HEAD
import 'package:mahe_chat/app/components/my_snackbar.dart';
=======
>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
import 'package:mahe_chat/app/router/router.dart';
import 'package:mahe_chat/core/utils/states_handler.dart';
import 'package:mahe_chat/features/auth/domain/provider/auth_notifier.dart';
import 'package:mahe_chat/features/chat/presentation/pages/home.dart';

<<<<<<< HEAD
import '../../../chat/presentation/components/my_snackbar.dart';

=======
<<<<<<< HEAD
=======
import '../../../chat/presentation/components/my_snackbar.dart';

>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
class LoginForm extends ConsumerStatefulWidget {
  final VoidCallback toggleAuthMode;

  const LoginForm({super.key, required this.toggleAuthMode});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final state = await ref.read(authProvider).login(
          _usernameController.text,
          _passwordController.text,
        );
    if (state is ErrorState) {
      MySnackBar.showMySnackBar(state.failure.message);
      return;
    }
    MyRouter.myPushReplacmentAll(context, HomePage());

    // Navigate to home screen on success
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Welcome Back',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to continue to MaheChat',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 32),

          // Username field
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1),

          const SizedBox(height: 16),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1),

          const SizedBox(height: 24),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to forgot password screen
              },
              child: const Text('Forgot Password?'),
            ),
          ).animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 16),

          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 24),

          // Or divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'OR',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ).animate(delay: 500.ms).fadeIn(),

          const SizedBox(height: 16),

          // Social login buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  final state = await ref.read(authProvider).loginGoogle();

                  if (state is ErrorState) {
                    MySnackBar.showMySnackBar(state.failure.message);
                    return;
                  }
                  MyRouter.myPushReplacmentAll(context, HomePage());
                },
                icon: Image.asset('assets/images/google.png', height: 24),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ],
          ).animate(delay: 600.ms).fadeIn(),
        ],
      ),
    );
  }
}
