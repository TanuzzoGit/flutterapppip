import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/myinputform.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'palette.dart' as pals;
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _loginState();
}

class _loginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController pswcontroller = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: pals.dividerStroke),
            borderRadius: BorderRadius.circular(15),
          ),
          width: 300,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyInputForm(controller: userController, label: "Nome Utente"),
              MyInputForm(controller: pswcontroller, label: "Password"),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final res = await http.post(
                    Uri.parse(
                      "${dotenv.env['PROD'] == 'true' ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/login",
                    ),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      "name": userController.text,
                      "psw": pswcontroller.text,
                    }),
                  );
                  final _user = json.decode(res.body) as Map<String, dynamic>;
                  print(_user);
                  prefs.setString("utente", _user['user']);
                  prefs.setBool("auth", _user['auth'] ?? false);
                  context.go('/');
                },
                child: Text("Logga"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
