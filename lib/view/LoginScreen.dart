import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_memoneet/viewmodel/AuthViewModel.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool showError = false;
  bool isLoggingIn = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Login',
          style:TextStyle(color: Colors.white) ,),
        backgroundColor: Colors.blue, // Change the app bar color
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
            SizedBox(height: 10),
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
              onPressed: isLoggingIn
                  ? null
                  : () {
                      if (email.isEmpty || password.isEmpty) {
                        // Show error message
                        setState(() {
                          errorMessage = "Invalid email or password";
                          showError = true;
                        });
                      } else {
                        // Start the login process
                        setState(() {
                          isLoggingIn = true;
                          showError = false; // Reset error message
                        });

                        // Handle login button press
                        Provider.of<AuthViewModel>(context, listen: false)
                            .signInWithEmailAndPassword(email, password)
                            .then((_) {
                          // Navigate to home screen if signed in successfully
                          Navigator.pushReplacementNamed(context, '/home');
                        }).catchError((error) {
                          // Handle login error
                          setState(() {
                            isLoggingIn = false;
                            errorMessage = error.toString();
                            showError = true;
                          });
                        });
                      }
                    },
              child: isLoggingIn ? CircularProgressIndicator() : Text('Login',style: TextStyle(fontSize: 16,color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to signup screen
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.blue), // Change the text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

