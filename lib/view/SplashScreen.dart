import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(  // Wrap your content in a Container
      color: Colors.white,  // Set the background color to white
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png',
             width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              fit: BoxFit.contain, ),
           
          ],
        ),
      ),
    );
  }
}
