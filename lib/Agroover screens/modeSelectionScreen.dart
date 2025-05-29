// import 'package:flutter/material.dart';
// import 'GuestOrderPage.dart';
// import 'Login_Screen.dart';

// class ModeSelectionScreen extends StatelessWidget {
//   const ModeSelectionScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: Container(
//                     color: Colors.green,
//                     child: Image.asset(
//                       "assets/images/ntuapplogo.png", // Logo path
//                       height: 150,
//                       fit: BoxFit.contain,
//                       color: Colors.white,
//                       colorBlendMode: BlendMode.srcATop,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),

//               // Title Text
//               Text(
//                 "Welcome to NTU Instant Delivery",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green[700],
//                   fontStyle: FontStyle.italic,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),

//               // Subtitle Text
//               Text(
//                 "Create an account and get 1 order free after 3 orders!",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.green[700],
//                   fontStyle: FontStyle.italic,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 40),

//               // Login/Sign Up Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   icon: Icon(Icons.login),
//                   label: Text(
//                     "Login / Sign Up",
//                     style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                     textStyle: TextStyle(fontSize: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => LoginScreen(themeisDark: false),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Guest Button
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton.icon(
//                   icon: Icon(Icons.person_outline),
//                   label: Text("Continue as Guest", style: TextStyle(fontWeight: FontWeight.bold),),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.green,
//                     side: BorderSide(color: Colors.green),
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                     textStyle: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:(context) => GuestOrderPage(),  // Pass true for guest mode
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
