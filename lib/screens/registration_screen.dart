import 'package:flash_chat/components/PaddingButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  String email = "";
  String password = "";
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
              PaddingButton(buttonText: 'Register', color: Colors.blueAccent, onPressed: () async {
                _saving = true;
                print(email);
                print(password);
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  print(newUser);
                  if (newUser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }catch(e){
                  print("==== Error ====");
                  print(e);
                }
                _saving = true;
              }),
            ],
          ),
        ),
        inAsyncCall: _saving,
      ),
    );
  }
}
