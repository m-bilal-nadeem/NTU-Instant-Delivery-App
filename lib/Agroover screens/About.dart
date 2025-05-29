import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  final bool isDarkTheme;

  const AboutUsPage({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkTheme ? Colors.black : Colors.white;
    Color cardColor = isDarkTheme ? Colors.grey[850]! : Colors.white;
    Color textColor = isDarkTheme ? Colors.white : Colors.black;
    Color titleColor = isDarkTheme ? Colors.greenAccent : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Card Content
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(20),
                color: cardColor,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // New Section: Main Introduction
                      Text(
                        "Introducing NTU Instant Delivery – Your On-Campus Convenience Partner!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Say goodbye to unnecessary trips to the NTU gate and enjoy instant access to anything you need, right from the comfort of your hostel or classroom! 🏠✨\n\n"
                        "NTU Instant Delivery is a specially designed delivery service for NTU students, especially hostel residents, who face difficulties stepping out due to harsh sunlight ☀️, or time constraints ⏰. We understand the struggles, which is why we're here to make life easier – with low delivery charges and fast, reliable service ⚡ till 11:00 PM 🌙.\n\n"
                        "Whether you're craving fast food from café 🍔, in need of stationery ✏️ for an assignment, or looking to buy fresh fruits 🍎, vegetables 🥦 (Vegetables, Grocery and Fruits only for hostel students), NTU Instant Delivery has got you covered! ✅\n\n"
                        "Our platform is built with care to support all students – especially our hostelite girls and boys ❤️, who often can’t go out to buy essential things like vegetables, fruits, grocery items, eatables and more.",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Existing Sections
                      Text(
                        "🚀 NTU Instant Delivery",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "We aim to simplify student life by providing fast and reliable delivery services within the NTU campus.",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "📱 Simple Ordering",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Just use our WhatsApp link to place an order — no app registration needed. We’re here to save your time!",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "👨‍💼 Meet the Founders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Muhammad Bilal Nadeem & Farasat Ali Gujjer — NTU students and tech enthusiasts, passionate about solving real-world problems with technology.",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: isDarkTheme ? Colors.grey : Colors.black12,
                      ),
                      Center(
                        child: Text(
                          "Thank you for supporting local student innovation!",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
