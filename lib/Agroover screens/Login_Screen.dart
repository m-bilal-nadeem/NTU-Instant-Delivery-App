// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';
// import '../widgets/UIHelper.dart';
// import 'GuestOrderPage.dart';
// import 'Sign_up.dart';
// import 'orderPage.dart';

// class AppColors {
//   static Color backgroundTop(bool isDark) =>
//       isDark ? Colors.black : Colors.green;
//   static Color backgroundBottom(bool isDark) =>
//       isDark ? Colors.grey[900]! : Colors.white;
//   static Color cardColor(bool isDark) =>
//       isDark ? Colors.grey[850]! : Colors.white;
//   static Color textColor(bool isDark) => isDark ? Colors.white : Colors.black;
//   static Color iconColor(bool isDark) => isDark ? Colors.white : Colors.black;
//   static Color buttonColor(bool isDark) => isDark ? Colors.black : Colors.green;
// }

// class LoginScreen extends StatefulWidget {
//   final bool themeisDark;
//   const LoginScreen({required this.themeisDark});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   late bool isDarkTheme;

//   @override
//   void initState() {
//     super.initState();
//     isDarkTheme = widget.themeisDark;
//   }

//   void toggleTheme() {
//     setState(() {
//       isDarkTheme = !isDarkTheme;
//     });
//   }

//   void login(String email, String password) async {
//     email = email.trim();
//     password = password.trim();

//     if (email.isEmpty || password.isEmpty || !EmailValidator.validate(email)) {
//       UIHelper.ShowSnackBar(
//         context,
//         "Please enter a valid email and password.",
//       );
//       return;
//     }

//     UIHelper.showLoadingDialog(context, "Logging In...");

//     try {
//       UserCredential credential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);

//       Navigator.pop(context); // Close the loading dialog

//       if (credential.user != null) {
//         UIHelper.ShowSnackBar(context, "Logged In Successfully!!");
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const OrderPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//     } on FirebaseAuthException catch (ex) {
//       Navigator.pop(context); // Close the loading dialog if login fails

//       String message;
//       switch (ex.code) {
//         case 'user-not-found':
//           message = 'No account found for this email.';
//           break;
//         case 'wrong-password':
//           message = 'Incorrect password.';
//           break;
//         case 'invalid-email':
//           message = 'The email address is not valid.';
//           break;
//         case 'user-disabled':
//           message = 'This user account has been disabled.';
//           break;
//         default:
//           message = ex.message ?? "An unknown error occurred.";
//       }
//       UIHelper.ShowSnackBar(context, message);
//     } catch (e) {
//       Navigator.pop(context); // Close dialog for other errors
//       UIHelper.ShowSnackBar(context, "Something went wrong. Please try again.");
//     }
//   }

//   InputDecoration buildInputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: isDarkTheme ? Colors.white : Colors.green),
//       hintStyle: TextStyle(
//         color: isDarkTheme ? Colors.white70 : Colors.black54,
//         fontStyle: FontStyle.italic,
//       ),
//       filled: true,
//       fillColor: isDarkTheme ? Colors.grey[850] : Colors.white,
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final backgroundTopColor = AppColors.backgroundTop(isDarkTheme);
//     final backgroundBottomColor = AppColors.backgroundBottom(isDarkTheme);
//     final cardColor = AppColors.cardColor(isDarkTheme);
//     final textColor = AppColors.textColor(isDarkTheme);
//     final iconColor = AppColors.iconColor(isDarkTheme);
//     final buttonColor = AppColors.buttonColor(isDarkTheme);

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: screenHeight,
//           child: Column(
//             children: [
//               Container(color: Colors.green, height: 60),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Container(
//                       color: backgroundTopColor,
//                       height: screenHeight * 0.45,
//                       width: double.infinity,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: screenWidth * 0.26,
//                             height: screenWidth * 0.26,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isDarkTheme ? Colors.grey : Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 10,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: ClipOval(
//                               child: Padding(
//                                 padding: EdgeInsets.all(4.0),
//                                 child: Image.asset(
//                                   "assets/images/ntuapplogo.png",
//                                   fit: BoxFit.cover,
//                                   color:
//                                       isDarkTheme ? Colors.white : Colors.green,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           Text(
//                             "Welcome Back!",
//                             style: TextStyle(
//                               fontStyle: FontStyle.italic,
//                               fontSize: screenWidth * 0.06,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.2),
//                         ],
//                       ),
//                     ),

//                     // Background Bottom
//                     Padding(
//                       padding: EdgeInsets.only(top: screenHeight * 0.32),
//                       child: Container(
//                         height: screenHeight * 0.9,
//                         decoration: BoxDecoration(
//                           color: backgroundBottomColor,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(40),
//                             topRight: Radius.circular(40),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Login Card
//                     Padding(
//                       padding: EdgeInsets.only(
//                         top: screenHeight * 0.235,
//                         left: screenWidth * 0.06,
//                         right: screenWidth * 0.06,
//                       ),
//                       child: Material(
//                         elevation: 10,
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.04,
//                             vertical: screenHeight * 0.025,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: screenWidth * 0.07,
//                                   fontStyle: FontStyle.italic,
//                                   color: textColor,
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.015),

//                               // Email
//                               Material(
//                                 elevation: 3,
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: TextField(
//                                   controller: emailController,
//                                   style: TextStyle(
//                                     color: textColor,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                                   decoration: buildInputDecoration(
//                                     'Email',
//                                     Icons.email,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.015),

//                               // Password
//                               Material(
//                                 elevation: 3,
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: TextField(
//                                   controller: passwordController,
//                                   obscureText: true,
//                                   style: TextStyle(
//                                     color: textColor,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                                   decoration: buildInputDecoration(
//                                     'Password',
//                                     Icons.lock,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.03),

//                               // Login Button
//                               GestureDetector(
//                                 onTap: () {
//                                   login(
//                                     emailController.text.trim(),
//                                     passwordController.text.trim(),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: screenHeight * 0.065,
//                                   width: screenWidth * 0.5,
//                                   decoration: BoxDecoration(
//                                     color: buttonColor,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: Center(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'Login',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                             fontStyle: FontStyle.italic,
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Icon(Icons.login, color: Colors.white),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(height: screenHeight * 0.03),

//                               // Signup Redirect
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Don\'t have an account?',
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.038,
//                                       color: textColor,
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder:
//                                               (context) => SignUpScreen(
//                                                 themeisDark: isDarkTheme,
//                                               ),
//                                         ),
//                                       );
//                                     },
//                                     child: Row(
//                                       children: [
//                                         SizedBox(width: 4),
//                                         Icon(
//                                           Icons.person_add,
//                                           color: iconColor,
//                                           size: screenWidth * 0.045,
//                                         ),
//                                         SizedBox(width: 2),
//                                         Text(
//                                           ' Sign Up',
//                                           style: TextStyle(
//                                             fontStyle: FontStyle.italic,
//                                             color: textColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: screenWidth * 0.04,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: screenHeight * 0.01),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Guest Button
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 600,
//                         left: 30,
//                         right: 30,
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: OutlinedButton.icon(
//                           icon: Icon(Icons.person_outline),
//                           label: Text(
//                             "Continue as Guest",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.green,
//                             side: BorderSide(color: Colors.green),
//                             padding: EdgeInsets.symmetric(vertical: 14),
//                             textStyle: TextStyle(
//                               fontSize: 16,
//                               fontStyle: FontStyle.italic,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => GuestOrderPage(),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
