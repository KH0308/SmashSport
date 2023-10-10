import 'package:flutter/material.dart';
import 'package:SmashSport/home_page.dart';
import 'colors.dart' as color;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCTRL = TextEditingController();
  final TextEditingController _passCTRL = TextEditingController();

  String msgToast = '';

  Future _login(BuildContext cont) async {

    if(_emailCTRL.text == "" || _passCTRL.text == ""){
      Fluttertoast.showToast(msg: "Both fields cannot be blank!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else{
      var url = Uri.parse("http://192.168.0.9:8080/FYP/Login.php");
      var response = await http.post(url, body: {
        "username": _emailCTRL.text,
        "password": _passCTRL.text,
      });

      var userData = json.decode(response.body);
      if(userData == "Success"){
        Navigator.push(cont, MaterialPageRoute(builder: (context) => HomePage()));
      }
      else {
        Fluttertoast.showToast(msg: "userID and password doesn't exist!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.AppColor.homePageBackground,
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _emailCTRL,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _passCTRL,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _login(context);
                      /*if (_formKey.currentState!.validate()) {
                        // Implement your login logic here
                        String email = _emailCTRL.text;
                        String password = _passCTRL.text;
                        // You can send the email and password to your server for authentication
                      }*/
                    },
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
