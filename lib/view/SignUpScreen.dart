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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Sign Up',
        style:TextStyle(color: Colors.white) ,),
      leading: BackButton(
        color: Colors.white,
      ),
      backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 30),
              child: Container(
                  child: Image.asset('assets/logo.png',
                    width: 200, // Adjust width as needed
                    height: 200, // Adjust height as needed
                    fit: BoxFit.contain, )
              ),
            ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
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
                  isSigningUp ? CircularProgressIndicator() : Text('Sign Up', style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), // Change the button color
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.pop(context);
              },
              child: Text('Already have an account? Login',
                style: TextStyle(color: Colors.blue),),
            ),
          ],
        ),
      ),
    );
  }
}
