// admin_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/UserManagementPage.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/chatroom_page.dart';
import 'package:ntu_instant_delievery/Chat_Screens/login_screen.dart';
import 'package:ntu_instant_delievery/Models/ChatRoomModel.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';
import 'package:ntu_instant_delievery/Models/MessageModel.dart';

class AdminPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AdminPage({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<ChatRoomModel> getChatroomModel(UserModel targetUser) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .where("participants.${widget.userModel.uid}", isEqualTo: true)
            .where("participants.${targetUser.uid}", isEqualTo: true)
            .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data() as Map<String, dynamic>;
      return ChatRoomModel.fromMap(docData);
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: DateTime.now().millisecondsSinceEpoch.toString(),
        lastMessage: "",
        participants: {widget.userModel.uid!: true, targetUser.uid!: true},
      );
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      return newChatroom;
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(themeisDark: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.green[700],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[700]),
              child: const Text(
                'Admin Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('User Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat Overview'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong!"));
            } else if (snapshot.hasData) {
              QuerySnapshot userSnapshot = snapshot.data as QuerySnapshot;
              List<UserModel> users =
                  userSnapshot.docs
                      .map((doc) {
                        Map<String, dynamic> userMap =
                            doc.data() as Map<String, dynamic>;
                        return UserModel.fromMap(userMap);
                      })
                      .where((user) => user.uid != widget.userModel.uid)
                      .toList();

              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  UserModel targetUser = users[index];
                  return FutureBuilder<ChatRoomModel>(
                    future: getChatroomModel(targetUser),
                    builder: (context, chatroomSnapshot) {
                      if (chatroomSnapshot.connectionState ==
                          ConnectionState.done) {
                        if (chatroomSnapshot.hasData) {
                          return _buildUserTile(
                            targetUser,
                            chatroomSnapshot.data!,
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text("No users found"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserTile(UserModel targetUser, ChatRoomModel chatroom) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(chatroom.chatroomid)
              .collection("messages")
              .orderBy("createdon", descending: true)
              .limit(1)
              .snapshots(),
      builder: (context, messageSnapshot) {
        String subtitle = "No messages yet";
        bool hasUnread = false;

        if (messageSnapshot.connectionState == ConnectionState.active) {
          if (messageSnapshot.hasData &&
              messageSnapshot.data!.docs.isNotEmpty) {
            var messageMap =
                messageSnapshot.data!.docs[0].data() as Map<String, dynamic>;
            MessageModel lastMessage = MessageModel.fromMap(messageMap);

            subtitle = lastMessage.text ?? "No messages";
            hasUnread =
                !(lastMessage.seen ?? true) &&
                lastMessage.sender != widget.userModel.uid;
          }
        }

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            tileColor: Colors.white,
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green.shade100,
              backgroundImage:
                  targetUser.profilepic != null &&
                          targetUser.profilepic!.isNotEmpty
                      ? NetworkImage(targetUser.profilepic!)
                      : null,
              child:
                  targetUser.profilepic == null ||
                          targetUser.profilepic!.isEmpty
                      ? const Icon(Icons.person, color: Colors.green)
                      : null,
            ),
            title: Text(
              targetUser.fullname ?? 'Unnamed User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing:
                hasUnread
                    ? const Icon(Icons.mark_chat_unread, color: Colors.red)
                    : const Icon(Icons.chat_bubble_outline, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChatRoomPage(
                        targetUser: targetUser,
                        chatRoom: chatroom,
                        userModel: widget.userModel,
                        firebaseuser: widget.firebaseUser,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
