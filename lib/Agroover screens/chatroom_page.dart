import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntu_instant_delievery/Models/ChatRoomModel.dart';
import 'package:ntu_instant_delievery/Models/MessageModel.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseuser;

  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.firebaseuser,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  Uuid uuid = Uuid();

  void sendMessage() async {
    String msg = messageController.text.trim();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        widget.userModel.uid,
        msg,
        false,
        DateTime.now(),
        uuid.v1(),
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid!)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .set(widget.chatRoom.toMap());

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          elevation: 4,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.targetUser.profilepic!),
              ),
              SizedBox(width: 12),
              Text(
                widget.targetUser.fullname ?? "Chat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Chat messages
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(widget.chatRoom.chatroomid!)
                          .collection("messages")
                          .orderBy("createdon", descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        for (var doc in dataSnapshot.docs) {
                          MessageModel msg = MessageModel.fromMap(
                            doc.data() as Map<String, dynamic>,
                          );
                          if (msg.sender != widget.userModel.uid &&
                              msg.seen == false) {
                            FirebaseFirestore.instance
                                .collection("chatrooms")
                                .doc(widget.chatRoom.chatroomid)
                                .collection("messages")
                                .doc(msg.messageid)
                                .update({"seen": true});
                          }
                        }

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>,
                            );
                            bool isSender =
                                currentMessage.sender == widget.userModel.uid;

                            return Align(
                              alignment:
                                  isSender
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors:
                                        isSender
                                            ? [
                                              Colors.green.shade300,
                                              Colors.green,
                                            ]
                                            : [
                                              Colors.grey.shade200,
                                              Colors.white,
                                            ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft:
                                        isSender
                                            ? Radius.circular(20)
                                            : Radius.circular(0),
                                    bottomRight:
                                        isSender
                                            ? Radius.circular(0)
                                            : Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      currentMessage.text.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            isSender
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                                    ),
                                    if (isSender)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Icon(
                                          Icons.done_all,
                                          size: 18,
                                          color:
                                              currentMessage.seen!
                                                  ? Colors.blue
                                                  : Colors.white70,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return Center(child: Text("Say hi 👋"));
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),

            // Input field and send button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade100,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade400,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
