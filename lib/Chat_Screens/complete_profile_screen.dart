import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntu_instant_delievery/Agroover%20screens/orderPage.dart';

import '../Models/UserModel.dart';
import '../widgets/UIHelper.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const CompleteProfile({
    Key? key,
    required this.userModel,
    required this.firebaseuser,
  }) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController fullnamecontroller = TextEditingController();
  File? imageFile;

  void showPhotooptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Upload Profile Picture",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.photo_album, color: Colors.green),
              title: Text("Select from Gallery"),
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: Colors.green),
              title: Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) cropImage(pickedFile);
  }

  void cropImage(XFile file) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
    );
    if (cropped != null) {
      setState(() => imageFile = File(cropped.path));
    }
  }

  void checkValues() {
    String fullname = fullnamecontroller.text.trim();
    if (fullname.isEmpty || imageFile == null) {
      UIHelper.errordialoag(context, "Incomplete Data\nPlease enter your full name and upload a profile picture",);
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask? uploadTask;
    if (imageFile != null) {
      UIHelper.showLoadingDialog(context, "Please wait...");
      uploadTask = FirebaseStorage.instance
          .ref("profilepictures/${widget.userModel.uid}")
          .putFile(imageFile!);
    }

    TaskSnapshot? snapshot = await uploadTask;
    String imageUrl = await snapshot!.ref.getDownloadURL();
    widget.userModel.fullname = fullnamecontroller.text.trim();
    widget.userModel.profilepic = imageUrl;

    UIHelper.showLoadingDialog(context, "Setting Up Profile...");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap());

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderPage(userModel: widget.userModel, firebaseuser: widget.firebaseuser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Complete Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: GlassContainer(
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: showPhotooptions,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.greenAccent, Colors.lightGreen],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: ClipOval(
                          child: imageFile != null
                              ? Image.file(imageFile!, fit: BoxFit.cover)
                              : Icon(Icons.camera_alt, size: 60, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: fullnamecontroller,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.green),
                      decoration: InputDecoration(
                        hintText: "Enter Your Full Name",
                        hintStyle: TextStyle(color: Colors.green.shade300),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: checkValues,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.greenAccent, Colors.lightGreen],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Glass Container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const GlassContainer({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
