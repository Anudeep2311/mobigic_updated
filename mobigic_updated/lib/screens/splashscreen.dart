import 'package:flutter/material.dart';
import 'package:mobigic_updated/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changePage() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GridSearchScreen(),
        ),
      );
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                    text: 'This is a MOBIGIC DEMO',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                    children: [
                      TextSpan(
                          text: '\n by Anudeep Lohogaonkar',
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 18))
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
