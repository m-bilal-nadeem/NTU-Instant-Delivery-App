import 'package:flutter/material.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
        content: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.green,),
              SizedBox(
                height: 30,
              ),
              Text(title),
            ],
          ),
        ));

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void errordialoag(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("An Error Occured"), content: Text(text)));
  }

  static void ShowSnackBar(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text(text),
        backgroundColor: Colors.green,
      )
    );
  }

  static void ShowSnackBar1(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(text, style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
        )
    );
  }

}
