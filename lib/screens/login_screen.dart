import 'package:flash_chat/components/PaddingButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  static String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'flash_logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: kRoundedInputDecoration.copyWith(hintText: 'Enter your email'),
              style: kInputStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration: kRoundedInputDecoration.copyWith(hintText: 'Enter your password'),
              style: kInputStyle,
              textAlign: TextAlign.center,
              obscureText: true,
            ),
            SizedBox(
              height: 24.0,
            ),
            PaddingButton(buttonText: 'Login', color: Colors.lightBlueAccent, onPressed: () {
            }),
          ],
        ),
      ),
    );
  }
}
