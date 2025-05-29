// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../main.dart';
// import '../widgets/UIHelper.dart';
// import 'GuestOrderPage.dart';
// import 'Login_Screen.dart';
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

// class SignUpScreen extends StatefulWidget {
//   final bool themeisDark;
//   const SignUpScreen({super.key, required this.themeisDark});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void signUp(String email, String password) async {
//     String name = nameController.text.trim();
//     email = emailController.text.trim();
//     password = passwordController.text.trim();

//     try {
//       bool isValidEmail = EmailValidator.validate(email);
//       if (name.isNotEmpty &&
//           email.isNotEmpty &&
//           password.isNotEmpty &&
//           isValidEmail) {
//         UIHelper.showLoadingDialog(context, "Please Wait....");

//         UserCredential credential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password);
//         await credential.user!.updateDisplayName(name);
//         await credential.user!.reload();
//         User? updatedUser = FirebaseAuth.instance.currentUser;

//         UIHelper.showLoadingDialog(context, "Creating Account....");

//         await FirebaseFirestore.instance
//             .collection("ntuUsers")
//             .doc(credential.user!.uid)
//             .set({
//               'uid': credential.user!.uid,
//               'name': name,
//               'email': email,
//               'password': password,
//             });

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('uid', credential.user!.uid);
//         await prefs.setString('name', name);
//         await prefs.setString('email', email);
//         await prefs.setString('password', password);

//         Navigator.pop(context);

//         if (updatedUser != null) {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => const OrderPage()),
//             (Route<dynamic> route) => false,
//           );
//           UIHelper.ShowSnackBar(context, "Account Created Successfully!!");
//         }
//       } else {
//         UIHelper.ShowSnackBar(context, "Fill all the fields correctly!");
//       }
//     } on FirebaseAuthException catch (ex) {
//       Navigator.pop(context);
//       UIHelper.ShowSnackBar(context, ex.message ?? "An error occurred");
//     } catch (e) {
//       Navigator.pop(context);
//       UIHelper.ShowSnackBar(context, "Error: ${e.toString()}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final bool isDark = widget.themeisDark;

//     final backgroundTopColor = AppColors.backgroundTop(isDark);
//     final backgroundBottomColor = AppColors.backgroundBottom(isDark);
//     final textColor = AppColors.textColor(isDark);
//     final buttonColor = AppColors.buttonColor(isDark);

//     InputDecoration buildInputDecoration(String hint, IconData icon) {
//       return InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon, color: isDark ? Colors.white : Colors.green),
//         hintStyle: TextStyle(
//           color: isDark ? Colors.white70 : Colors.black54,
//           fontStyle: FontStyle.italic,
//         ),
//         filled: true,
//         fillColor: isDark ? Colors.grey[850] : Colors.white,
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//       );
//     }

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40, child: ColoredBox(color: Colors.green)),
//             Stack(
//               children: [
//                 Container(
//                   color: backgroundTopColor,
//                   height: screenHeight * 0.45,
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: screenWidth * 0.26,
//                         height: screenWidth * 0.26,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: isDark ? Colors.grey : Colors.white,
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 10,
//                               offset: Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: ClipOval(
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Image.asset(
//                               "assets/images/ntuapplogo.png",
//                               fit: BoxFit.cover,
//                               color: isDark ? Colors.white : Colors.green,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       Text(
//                         "Let's get started!",
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.06,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.2),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenHeight * 0.32),
//                   child: Container(
//                     height: screenHeight * 0.63,
//                     decoration: BoxDecoration(
//                       color: backgroundBottomColor,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: screenHeight * 0.235,
//                     left: screenWidth * 0.06,
//                     right: screenWidth * 0.06,
//                   ),
//                   child: Material(
//                     elevation: 10,
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.04,
//                         vertical: screenHeight * 0.025,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: screenWidth * 0.07,
//                               fontStyle: FontStyle.italic,
//                               color: textColor,
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.015),
//                           Material(
//                             elevation: 3,
//                             borderRadius: BorderRadius.circular(12),
//                             child: TextField(
//                               controller: nameController,
//                               style: TextStyle(
//                                 color: textColor,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               decoration: buildInputDecoration(
//                                 'Name',
//                                 Icons.person,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.015),
//                           Material(
//                             elevation: 3,
//                             borderRadius: BorderRadius.circular(12),
//                             child: TextField(
//                               controller: emailController,
//                               style: TextStyle(
//                                 color: textColor,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               decoration: buildInputDecoration(
//                                 'Email',
//                                 Icons.email,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.015),
//                           Material(
//                             elevation: 3,
//                             borderRadius: BorderRadius.circular(12),
//                             child: TextField(
//                               controller: passwordController,
//                               obscureText: true,
//                               style: TextStyle(
//                                 color: textColor,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               decoration: buildInputDecoration(
//                                 'Password',
//                                 Icons.password,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.03),
//                           GestureDetector(
//                             onTap:
//                                 () => signUp(
//                                   emailController.text.trim(),
//                                   passwordController.text.trim(),
//                                 ),
//                             child: Container(
//                               height: screenHeight * 0.065,
//                               width: screenWidth * 0.5,
//                               decoration: BoxDecoration(
//                                 color: buttonColor,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.person_add,
//                                     color: Colors.white,
//                                     size: 20,
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     'Sign Up',
//                                     style: TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.03),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Already have an account?',
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.038,
//                                   color: textColor,
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               Icon(Icons.login, color: textColor, size: 20),
//                               const SizedBox(width: 1),
//                               GestureDetector(
//                                 onTap:
//                                     () => Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder:
//                                             (context) => LoginScreen(
//                                               themeisDark: widget.themeisDark,
//                                             ),
//                                       ),
//                                     ),
//                                 child: Text(
//                                   ' Login',
//                                   style: TextStyle(
//                                     fontStyle: FontStyle.italic,
//                                     color: textColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: screenWidth * 0.04,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 630, left: 40, right: 40),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton.icon(
//                       icon: const Icon(Icons.person_outline),
//                       label: const Text(
//                         "Continue as Guest",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.green,
//                         side: const BorderSide(color: Colors.green),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(
//                           fontSize: 16,
//                           fontStyle: FontStyle.italic,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const GuestOrderPage(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
