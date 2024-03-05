// signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_memoneet/viewmodel/AuthViewModel.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  String email = '';
  String password = '';
  bool showError = false;
  bool isSigningUp = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) => password = value,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            if (showError)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (email.isEmpty || password.isEmpty) {
                  // Show error message
                  setState(() {
                    errorMessage = "Please provide a valid email and password.";
                    showError = true;
                  });
                } else {
                  setState(() {
                    isSigningUp = true;
                    showError = false;
                  });
                  Provider.of<AuthViewModel>(context, listen: false)
                      .signUpWithEmailAndPassword(email, password)
                      .then((_) {
                    // Navigate to home screen if signed up successfully
                    Navigator.pushReplacementNamed(context, '/home');
                  }).catchError((error) {
                    // Handle signup error
                    setState(() {
                      isSigningUp = false;
                      errorMessage = error.toString();
                      showError = true;
                    });
                  });
                }
              },
              child:
                  isSigningUp ? CircularProgressIndicator() : Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.pop(context);
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
