import 'package:flutter/material.dart';

class PaddingButton extends StatelessWidget {

  final String buttonText;
  final Color color;
  final Function? onPressed;
  PaddingButton({ required this.buttonText, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            if (onPressed != null){
              onPressed!();
            }
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
          ),
        ),
      ),
    );
  }
}
