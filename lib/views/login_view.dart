import 'package:flutter/material.dart';
import 'package:mindwave/controllers/app_controller.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
      
  @override
  Widget build(BuildContext context) {
    final appCtrl = context.watch<AppController>();
    final authCtrl = context.watch<AuthController>();
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'lib/assets/mindwave_logo.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's get learning!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: authCtrl.emailController,
                decoration: InputDecoration(
                  hintText: 'Example@email.com',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authCtrl.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'At least 8 characters',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => authCtrl.resetPassword(context),
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => authCtrl.signIn(context),
                  child: const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Or sign in with"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => authCtrl.signInWithGoogle(context),
                  icon: Image.asset(
                    'lib/assets/google_icon.png',
                    height: 20,
                  ),
                  label: const Text('Google'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't you have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}