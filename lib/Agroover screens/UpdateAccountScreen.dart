import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';
import 'package:ntu_instant_delievery/widgets/UIHelper.dart';

class UpdateAccountPage extends StatefulWidget {
  final UserModel userModel;

  const UpdateAccountPage({super.key, required this.userModel});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userModel.fullname ?? "";
    _emailController.text = widget.userModel.email ?? "";
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _updateDetails() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Confirm Update",),
            content: Text("Do you want to save these changes?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel",style: TextStyle(color: Colors.grey[500]),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Confirm",style: TextStyle(color: Colors.green),),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    setState(() => _isUploading = true);

    try {
      String uid = widget.userModel.uid!;
      String? profilePicUrl = widget.userModel.profilepic;

      // Upload new image if selected
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance.ref().child(
          "profile_pictures/$uid.jpg",
        );
        await ref.putFile(_imageFile!);
        profilePicUrl = await ref.getDownloadURL();
      }

      UIHelper.showLoadingDialog(context, "Saving Changes...");

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fullname': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'profilepic': profilePicUrl,
      });

      UIHelper.ShowSnackBar(context, 'Account updated successfully');
      Navigator.pop(context);
    } catch (e) {
      UIHelper.ShowSnackBar(context, 'Error: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl = widget.userModel.profilepic;

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Account"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body:
          _isUploading
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : (profileUrl != null &&
                                        profileUrl.isNotEmpty)
                                    ? NetworkImage(profileUrl) as ImageProvider
                                    : AssetImage('assets/default_profile.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _updateDetails,
                      icon: Icon(Icons.save),
                      label: Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
