// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'Login_Screen.dart';
// import 'About.dart';
// import 'Sign_up.dart';
// import 'Terms.dart';

// class GuestOrderPage extends StatefulWidget {
//   const GuestOrderPage({Key? key}) : super(key: key);

//   @override
//   _GuestOrderPageState createState() => _GuestOrderPageState();
// }

// class _GuestOrderPageState extends State<GuestOrderPage> {
//   final _nameController = TextEditingController();
//   final _orderController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final String vendorNumber = "+923114594563";

//   void _openWhatsApp() async {
//     if (!_formKey.currentState!.validate()) return;

//     final message = '''
// 👋 *Hi there!* 

// 🧍‍♂️ *Name:* ${_nameController.text.trim()}
// 📍 *Location:* ${_locationController.text.trim()}
// 🛒 *Order Details:* ${_orderController.text.trim()}

// ❓Can you deliver this to my location?

// Thanks! 😊
// ''';

//     final String phone = vendorNumber.replaceAll('+', '');

//     final Uri whatsappUrl = Uri.parse(
//       "https://wa.me/$phone?text=${Uri.encodeFull(message)}",
//     );

//     final Uri whatsappIntent = Uri.parse(
//       "intent://send?phone=$phone&text=${Uri.encodeFull(message)}#Intent;package=com.whatsapp;scheme=smsto;end",
//     );

//     try {
//       if (await canLaunchUrl(whatsappUrl)) {
//         await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
//       } else if (await canLaunchUrl(whatsappIntent)) {
//         await launchUrl(whatsappIntent, mode: LaunchMode.externalApplication);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Could not launch WhatsApp")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error launching WhatsApp: $e")),
//       );
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.green),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.person, size: 35, color: Colors.green),
//                   ),
//                   SizedBox(width: 2,),
//                   Text(
//                     "NTU Delivery Menu",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (_) => LoginScreen(themeisDark: false),
//                           ));
//                         },
//                         child: Text("| Login |", style: TextStyle(fontSize: 15,color: Colors.white, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
//                       ),

//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (_) => SignUpScreen(themeisDark: false),
//                           ));
//                         },
//                         child: Text("| Signup |", style: TextStyle(fontSize: 15,color: Colors.white, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.info_outline),
//               title: Text("About"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(
//                   builder: (_) => AboutUsPage(isDarkTheme: false),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.library_books),
//               title: Text("Terms & Conditions"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(
//                   builder: (_) => TermsPage(isDarkTheme: false),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.login),
//               title: Text("Login / Sign Up"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(
//                   builder: (context) => LoginScreen(themeisDark: false),
//                 ));
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.delivery_dining, color: Colors.white),
//             SizedBox(width: 10),
//             Flexible(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   "NTU Instant Delivery",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontStyle: FontStyle.italic
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               elevation: 10,
//               shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Form(
//                   key: _formKey,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   child: Column(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(80),
//                         child: Container(
//                           color: Colors.green,
//                           child: Image.asset(
//                             "assets/images/ntuapplogo.png",
//                             height: 150,
//                             fit: BoxFit.contain,
//                             color: Colors.white,
//                             colorBlendMode: BlendMode.srcATop,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "Place Your Order",
//                         style: TextStyle(
//                           fontStyle: FontStyle.italic,
//                           fontSize: constraints.maxWidth < 400 ? 20 : 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: "Your Name",
//                           labelStyle: TextStyle(fontStyle: FontStyle.italic),
//                           prefixIcon: Icon(Icons.person),
//                         ),
//                         validator: (value) => value == null || value.trim().isEmpty
//                             ? "*Please enter your name"
//                             : null,
//                       ),
//                       SizedBox(height: 15),
//                       TextFormField(
//                         controller: _orderController,
//                         decoration: InputDecoration(
//                           labelStyle: TextStyle(fontStyle: FontStyle.italic),
//                           labelText: "What do you want to order?",
//                           prefixIcon: Icon(Icons.inventory_2_rounded),
//                         ),
//                         maxLines: 3,
//                         validator: (value) => value == null || value.trim().isEmpty
//                             ? "Please enter order details"
//                             : null,
//                       ),
//                       SizedBox(height: 15),
//                       TextFormField(
//                         controller: _locationController,
//                         decoration: InputDecoration(
//                           labelStyle: TextStyle(fontStyle: FontStyle.italic),
//                           labelText: "Your Location (Slide, Block, etc.)",
//                           prefixIcon: Icon(Icons.location_on),
//                         ),
//                         validator: (value) => value == null || value.trim().isEmpty
//                             ? "*Please enter your location"
//                             : null,
//                       ),
//                       SizedBox(height: 40),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(41),
//                         child: SizedBox(
//                           width: 300,
//                           height: 55,
//                           child: ElevatedButton.icon(
//                             icon: Icon(Icons.send),
//                             label: Text(
//                               "Send Order via WhatsApp",
//                               style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//                             ),
//                             onPressed: _openWhatsApp,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
