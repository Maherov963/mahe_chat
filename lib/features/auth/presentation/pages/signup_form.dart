import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mahe_chat/app/router/router.dart';

import '../../../chat/presentation/pages/home.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback toggleAuthMode;

  const SignupForm({super.key, required this.toggleAuthMode});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedAge;
  final List<String> _ageOptions =
      List.generate(87, (index) => (index + 13).toString());

  // final _phoneController = TextEditingController();
  // File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   setState(() {
    //     _profileImage = File(pickedFile.path);
    //   });
    // }
  }

  Future<void> _submit() async {
    MyRouter.myPushReplacmentAll(context, HomePage());
    // if (!_formKey.currentState!.validate()) return;
    // if (_profileImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please select a profile image')),
    //   );
    //   return;
    // }

    // setState(() => _isLoading = true);

    // // Simulate API call
    // await Future.delayed(const Duration(seconds: 2));

    // setState(() => _isLoading = false);

    // Navigate to home screen on success
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join MaheChat today',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 24),

          // // Profile image picker
          // GestureDetector(
          //   onTap: _pickImage,
          //   child: CircleAvatar(
          //       radius: 50,
          //       backgroundColor: Colors.blue.shade100,
          //       backgroundImage: null,
          //       // _profileImage != null ? FileImage(_profileImage!) : ,
          //       child:
          //           //  _profileImage == null?
          //           const Icon(Icons.add_a_photo, size: 30, color: Colors.blue)
          //       // : null,
          //       ),
          // ).animate(delay: 100.ms).fadeIn().scale(),

          // const SizedBox(height: 24),

          // Username field
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1),

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
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1),

          const SizedBox(height: 16),

          // Confirm password field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.1),

          const SizedBox(height: 16),

          // Age DropdownButtonFormField
          DropdownButtonFormField<String>(
            value: _selectedAge,
            dropdownColor: const Color.fromARGB(255, 52, 51, 58),
            decoration: InputDecoration(
              labelText: 'Age',
              prefixIcon:
                  Icon(Icons.calendar_today, color: Colors.grey.shade400),
              filled: true,
              fillColor: const Color.fromARGB(255, 52, 51, 58),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
            hint: Text('Select your age',
                style: TextStyle(color: Colors.grey.shade500)),
            items: _ageOptions.map((age) {
              return DropdownMenuItem<String>(
                value: age,
                child: Text(age, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select your age' : null,
            onChanged: (value) {
              setState(() {
                _selectedAge = value;
              });
            },
          ).animate(delay: 500.ms).fadeIn().slideX(begin: -0.1),
          const SizedBox(height: 16),

          // Phone number field
          // TextFormField(
          //   controller: _phoneController,
          //   keyboardType: TextInputType.phone,
          //   decoration: const InputDecoration(
          //     labelText: 'Phone Number',
          //     prefixIcon: Icon(Icons.phone),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your phone number';
          //     }
          //     return null;
          //   },
          // ).animate(delay: 600.ms).fadeIn().slideX(begin: -0.1),

          // const SizedBox(height: 24),

          // Signup button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }
}
