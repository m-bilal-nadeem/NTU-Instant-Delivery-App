import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  final bool isDarkTheme;

  const TermsPage({super.key, required this.isDarkTheme});

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
        iconTheme: IconThemeData(color: isDarkTheme ? Colors.white : Colors.white),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkTheme ? Colors.grey : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Image.asset(
                      "assets/images/ntuapplogo.png",
                      fit: BoxFit.cover,
                      color: isDarkTheme ? Colors.white : Colors.green,
                    ),
                  ),
                ),
              ),
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
                      Text(
                        "📜 Terms & Conditions",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "By using NTU Instant Delivery, you agree to the following terms:\n\n",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        "• Orders are only accepted within NTU campus.\n",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "• Delivery charges may apply based on location and time.\n",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "• Orders placed after 11 PM will be fulfilled the next day.\n",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "• We reserve the right to refuse delivery under unforeseen circumstances.\n\n",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Thank you for using our service responsibly!",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: isDarkTheme ? Colors.grey : Colors.black12),
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
