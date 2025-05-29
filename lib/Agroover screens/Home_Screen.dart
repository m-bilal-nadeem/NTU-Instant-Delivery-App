import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int val = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGROROVER'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(1000, 80, 10, 0),
                items: [
                  PopupMenuItem(
                    child: Text('Edit Profile'),
                    value: 'edit_profile',
                  ),
                  PopupMenuItem(
                    child: Text('Logout'),
                    value: 'logout',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'AGROROVER',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text('Terms & Conditions'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User Profile'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_remote),
              title: Text('Live Controls'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiveControlsScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Live Video Feed'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiveVideoFeedScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            val = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
      body: Center(
        child: Text(
          'Welcome to AgroRover!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Pages

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'AgroRover is an advanced agriculture platform that helps farmers manage their land with smart tech and automation.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'By using AgroRover, you agree to follow all terms, use it responsibly, and not misuse any features for unintended purposes.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('User Profile')), body: Center(child: Text('User Profile Page')));
  }
}

class LiveControlsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Live Controls')), body: Center(child: Text('Live Controls Page')));
  }
}

class LiveVideoFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Live Video Feed')), body: Center(child: Text('Live Video Feed Page')));
  }
}

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Contact Us')), body: Center(child: Text('Contact Us Page')));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Settings')), body: Center(child: Text('Settings Page')));
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Privacy Policy')), body: Center(child: Text('Privacy Policy Page')));
  }
}