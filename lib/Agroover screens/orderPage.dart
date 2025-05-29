// OrderPage.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntu_instant_delievery/Agroover screens/chatroom_page.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/DeleteAccountScreen.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/UpdateAccountScreen.dart';
import 'package:ntu_instant_delievery/Chat_Screens/login_screen.dart';
import 'package:ntu_instant_delievery/Models/ChatRoomModel.dart';
import 'package:ntu_instant_delievery/Models/MessageModel.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';
import 'package:uuid/uuid.dart';
import '../widgets/UIHelper.dart';
import 'About.dart';
import 'Terms.dart';

class OrderPage extends StatefulWidget {
  final bool isGuest;
  final UserModel userModel;
  final User firebaseuser;

  const OrderPage({
    super.key,
    this.isGuest = false,
    required this.userModel,
    required this.firebaseuser,
  });

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _nameController = TextEditingController();
  final _orderController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ChatRoomModel? chatRoom;
  final uuid = Uuid();
  final String adminUID = "uiTyUxby2XdIQiUMsIglvaRqfZF3";
  bool hasUnreadMessages = false;

  @override
  void initState() {
    super.initState();
    _checkUnreadMessages();
  }

  Future<void> _checkUnreadMessages() async {
    try {
      QuerySnapshot chatSnapshot =
          await FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .get();

      for (var doc in chatSnapshot.docs) {
        var chatRoomId = doc.id;
        QuerySnapshot msgSnapshot =
            await FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(chatRoomId)
                .collection("messages")
                .where("seen", isEqualTo: false)
                .where("sender", isNotEqualTo: widget.userModel.uid)
                .get();

        if (msgSnapshot.docs.isNotEmpty) {
          setState(() {
            hasUnreadMessages = true;
          });
          return;
        }
      }

      setState(() {
        hasUnreadMessages = false;
      });
    } catch (e) {
      print("Error checking unread messages: $e");
    }
  }

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .where("participants.${targetUser.uid}", isEqualTo: true)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var docData = doc.data() as Map<String, dynamic>;
        docData['chatroomid'] = doc.id; // Ensure chatroom ID is set
        chatRoom = ChatRoomModel.fromMap(docData);
      } else {
        ChatRoomModel newChatRoom = ChatRoomModel(
          chatroomid: uuid.v1(),
          participants: {widget.userModel.uid!: true, targetUser.uid!: true},
          lastMessage: "",
        );
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(newChatRoom.chatroomid)
            .set(newChatRoom.toMap());

        chatRoom = newChatRoom;

        UIHelper.ShowSnackBar(context, "Order Placed Successfully");
      }

      return chatRoom;
    } catch (e) {
      UIHelper.errordialoag(context, "Error getting chat room: $e");
      return null;
    }
  }

  Future<UserModel?> fetchUserById(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        UIHelper.errordialoag(context, "User not found with UID: $uid");
        return null;
      }
    } catch (e) {
      UIHelper.errordialoag(context, "Error fetching user: $e");
      return null;
    }
  }

  void _sendOrderAndNavigateToChat() async {
    if (!_formKey.currentState!.validate()) return;

    final message = '''
👋 Hi there!

📞 Phone: ${_nameController.text.trim()}
📍 Location: ${_locationController.text.trim()}
🛒 Order Details: ${_orderController.text.trim()}

❓Can you deliver this to my location?

Thanks! 😊
''';
    UIHelper.showLoadingDialog(context, "Placing Order...");
    UserModel? adminModel = await fetchUserById(adminUID);
    if (adminModel != null) {
      ChatRoomModel? chatRoomModel = await getChatRoomModel(adminModel);

      if (chatRoomModel != null) {
        MessageModel orderMessage = MessageModel(
          widget.userModel.uid,
          message,
          false,
          DateTime.now(),
          uuid.v1(),
        );
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomModel.chatroomid)
            .collection("messages")
            .doc(orderMessage.messageid)
            .set(orderMessage.toMap());

        chatRoomModel.lastMessage = message;
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomModel.chatroomid)
            .set(chatRoomModel.toMap());
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatRoomPage(
                  userModel: widget.userModel,
                  targetUser: adminModel,
                  chatRoom: chatRoomModel,
                  firebaseuser: widget.firebaseuser,
                ),
          ),
        );
      }
    }
  }

  void _navigateToSavedChatRoom() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .where("participants.${widget.userModel.uid}", isEqualTo: true)
            .where("participants.$adminUID", isEqualTo: true)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      var docData = doc.data() as Map<String, dynamic>;
      docData['chatroomid'] = doc.id; // Assign chatroomid
      chatRoom = ChatRoomModel.fromMap(docData);

      UserModel? adminModel = await fetchUserById(adminUID);
      if (adminModel != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ChatRoomPage(
                  userModel: widget.userModel,
                  targetUser: adminModel,
                  chatRoom: chatRoom!,
                  firebaseuser: widget.firebaseuser,
                ),
          ),
        );
        return;
      }
    }

    UIHelper.ShowSnackBar(
      context,
      "No previous order found.\nMake order first to continue chat..",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, color: Colors.white),
            SizedBox(width: 10),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "NTU Instant Delivery",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where(
                      "participants.${widget.userModel.uid}",
                      isEqualTo: true,
                    )
                    .snapshots(),
            builder: (context, chatSnapshot) {
              if (!chatSnapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: _navigateToSavedChatRoom,
                );
              }

              final chatDocs = chatSnapshot.data!.docs;
              List<Future<QuerySnapshot>> unreadMessageFutures = [];

              for (var chatDoc in chatDocs) {
                String chatRoomId = chatDoc.id;
                var unreadQuery =
                    FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(chatRoomId)
                        .collection("messages")
                        .where("seen", isEqualTo: false)
                        .where("sender", isNotEqualTo: widget.userModel.uid)
                        .get();
                unreadMessageFutures.add(unreadQuery);
              }

              return FutureBuilder<List<QuerySnapshot>>(
                future: Future.wait(unreadMessageFutures),
                builder: (context, unreadSnapshots) {
                  bool hasUnread = false;

                  if (unreadSnapshots.hasData) {
                    for (var snapshot in unreadSnapshots.data!) {
                      if (snapshot.docs.isNotEmpty) {
                        hasUnread = true;
                        break;
                      }
                    }
                  }

                  return IconButton(
                    icon: Stack(
                      children: [
                        Icon(hasUnread ? Icons.mark_chat_unread : Icons.chat),
                        if (hasUnread)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: _navigateToSavedChatRoom,
                  );
                },
              );
            },
          ),
        ],
      ),

      body: _buildFormBody(context),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      widget.userModel.profilepic != null &&
                              widget.userModel.profilepic!.isNotEmpty
                          ? NetworkImage(widget.userModel.profilepic!)
                          : null,
                  backgroundColor: Colors.white,
                  child:
                      widget.userModel.profilepic == null ||
                              widget.userModel.profilepic!.isEmpty
                          ? Icon(Icons.person, size: 35, color: Colors.green)
                          : null,
                ),
                SizedBox(height: 12),
                Text(
                  widget.userModel.fullname ?? "NTU User",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.userModel.email ?? "",
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                if (widget.isGuest)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(themeisDark: false),
                          ),
                        );
                      },
                      child: Text(
                        "Login / Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.info_outline, "About", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutUsPage(isDarkTheme: false),
              ),
            );
          }),
          _buildDrawerItem(Icons.library_books, "Terms & Conditions", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TermsPage(isDarkTheme: false)),
            );
          }),
          _buildDrawerItem(Icons.edit, "Update Account Details", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UpdateAccountPage(userModel: widget.userModel),
              ),
            );
          }),
          _buildDrawerItem(Icons.delete_forever, "Delete Account", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeleteAccountPage(uid: widget.userModel.uid!),
              ),
            );
          }),
          _buildDrawerItem(Icons.login, "Login another account", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(themeisDark: false),
              ),
            );
          }),
          _buildDrawerItem(Icons.refresh, "Refresh App", () {
            _formKey.currentState?.reset();
            _nameController.clear();
            _orderController.clear();
            _locationController.clear();
            Navigator.pop(context);
            UIHelper.ShowSnackBar(context, "App Refreshed Successfully!!");
          }),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(themeisDark: false),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  Widget _buildFormBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        color: Colors.green,
                        child: Image.asset(
                          "assets/images/ntuapplogo.png",
                          height: 150,
                          fit: BoxFit.contain,
                          color: Colors.white,
                          colorBlendMode: BlendMode.srcATop,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Enter your phone",
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter your phone number'
                                  : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: "Enter your location",
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter your location'
                                  : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _orderController,
                      maxLines: null,
                      decoration: InputDecoration(labelText: "Order details"),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter order details'
                                  : null,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _sendOrderAndNavigateToChat,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Place Your Order",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
