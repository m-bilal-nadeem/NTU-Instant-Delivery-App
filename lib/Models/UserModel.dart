import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String role;

  // Constructor with default role
  UserModel(
    this.uid,
    this.fullname,
    this.email,
    this.profilepic, {
    this.role = "user",
  });

  // Create object from map
  UserModel.fromMap(Map<String, dynamic> map)
    : uid = map["uid"],
      fullname = map["fullname"],
      email = map["email"],
      profilepic = map["profilepic"],
      role = map["role"] ?? "user"; // Default to "user" if null

  // Convert object to map
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "role": role,
    };
  }
}
