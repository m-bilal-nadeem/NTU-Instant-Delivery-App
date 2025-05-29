import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/Admin.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/orderPage.dart';
import 'package:ntu_instant_delievery/Chat_Screens/login_screen.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA-jGVhvd1XZDttL7CFAznq3Dzm9TsAuNU",
      appId: "1:131390803654:android:1d39c93e65b1abeffd91c7",
      messagingSenderId: "131390803654",
      projectId: "my-app-296d4",
      storageBucket: "my-app-296d4.appspot.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.green;

    return MaterialApp(
      title: 'NTU Instant Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.green[50],
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 6,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(bodyLarge: TextStyle(fontSize: 18)),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          floatingLabelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          prefixIconColor: primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      home:
          FirebaseAuth.instance.currentUser != null
              ? FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.exists) {
                    UserModel userModel = UserModel.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>,
                    );

                    final currentUser = FirebaseAuth.instance.currentUser!;

                    if (currentUser.email == "bilalnadeem2005kb@gmail.com") {
                      return AdminPage(
                        userModel: userModel,
                        firebaseUser: currentUser,
                      );
                    } else {
                      return OrderPage(
                        userModel: userModel,
                        firebaseuser: currentUser,
                      );
                    }
                  } else {
                    return LoginScreen(themeisDark: false);
                  }
                },
              )
              : LoginScreen(themeisDark: false),
    );
  }
}
