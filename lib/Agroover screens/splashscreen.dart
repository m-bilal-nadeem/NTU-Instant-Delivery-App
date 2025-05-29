import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/Admin.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/Home_Screen.dart';
import 'package:ntu_instant_delievery/Chat_Screens/login_screen.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';
import 'orderPage.dart';
import 'modeSelectionScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 1700), () {
      _textController.forward();
    });

    Timer(const Duration(seconds: 4), () async {
      await handleUserRedirection();
    });
  }

  Future<void> handleUserRedirection() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(themeisDark: false),
        ),
      );
      return;
    }

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (!userDoc.exists || userDoc.data() == null) {
        // No user data found, fallback
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(themeisDark: false),
          ),
        );
        return;
      }

      // Convert map to UserModel
      UserModel userModel = UserModel.fromMap(
        userDoc.data() as Map<String, dynamic>,
      );
      String role = userModel.role;

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminPage(firebaseUser: user, userModel: userModel),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderPage(firebaseuser: user, userModel: userModel),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error fetching user role or user model: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(themeisDark: false),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoAnimation,
                child: Container(
                  width: screenWidth * 0.35,
                  height: screenWidth * 0.35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/ntuapplogo.png",
                        color: Colors.green,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  "NTU Instant Delivery",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  "Welcome to NTU Instant Delivery!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenWidth * 0.045,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Text(
                "v1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
