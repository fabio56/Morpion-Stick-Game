import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final title  ;
  final VoidCallback callback ;

  CustomButton(this.title , this.callback);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:80),
      child: Container(
        width: 250,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.red)
          ),
          padding: EdgeInsets.all(8),
          onPressed: callback,
          child: Text(
            title,
            style: TextStyle(color: Colors.white , fontSize: 20),
          ),
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
