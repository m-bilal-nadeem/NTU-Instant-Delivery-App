import 'package:firebase_auth/firebase_auth.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  

  ChatRoomModel({
    required this.chatroomid,
    required this.participants,
    required this.lastMessage,
  });

  // Map to data
  ChatRoomModel.fromMap(Map<String, dynamic>? map) {
    chatroomid = map!["chatroomid"];
    participants = map["participants"]!;
    lastMessage = map["lastMessage"];
  }

  set lastMessageTime(DateTime lastMessageTime) {}

  // data to Map
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastMessage": lastMessage,
    };
  }
}
