// ignore_for_file: dead_code, deprecated_member_use, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:androidfull2/api/apiconfig.dart';
import 'package:androidfull2/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({Key? key}) : super(key: key);

  @override
  _LoginPagesState createState() => _LoginPagesState();
}

enum LoginStatus {
  notSigIn,
  sigIn,
}

class _LoginPagesState extends State<LoginPages> {
  LoginStatus _loginStatus = LoginStatus.notSigIn;

  late String txtusername, txtpassword;
  final _key = GlobalKey<FormState>();

  bool _secureText = true;
  showSecure() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  _check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      _login();
      // print("${txtusername}, ${txtpassword}");
    }
  }

  _login() async {
    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl() + "login"),
      body: {
        'email': txtusername,
        'password': txtpassword,
      },
      headers: {
        'Accept': 'application/json',
      },
    );
    var value = response.statusCode;
    if (value == 200) {
      var getdata = jsonDecode(response.body);
      // print(value);
      var token = getdata["token"];
      var name = getdata["user"]["name"];
      var email = getdata["user"]["email"];
      setState(() {
        _loginStatus = LoginStatus.sigIn;
        savePreference(value, token, name, email);
      });
      // print(token);
    } else {
      Alert(
        context: context,
        title: "ERROR !!!",
        desc: "please check your email and password !!!",
      ).show();
    }
  }

  savePreference(int value, String token, name, email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("token", token);
      preferences.commit();
    });
  }

  var oktoken;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      // value = preferences.getInt("value");
      oktoken = preferences.getString("token");
      _loginStatus = oktoken != null ? LoginStatus.sigIn : LoginStatus.notSigIn;
    });
  }

  ceklogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      oktoken = preferences.getString("token");
      _loginStatus = oktoken != null ? LoginStatus.sigIn : LoginStatus.notSigIn;
    });

    final response =
        await http.get(Uri.parse(ApiConfig.apiUrl() + "me"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $oktoken',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      var ok = response.statusCode;
      // print("oktdata");
      setState(() {
        _loginStatus = ok == 200 ? LoginStatus.sigIn : LoginStatus.notSigIn;
      });
    } else {
      setState(() {
        signOut();
      });
    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 1);
      preferences.commit();
      _loginStatus = LoginStatus.notSigIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    ceklogin();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSigIn:
        return Scaffold(
          body: Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 75, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Wellcome Back",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      // email
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.2),
                          hintText: "Example@gmail.com",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSaved: (e) => txtusername = e!,
                        // controller: txtusername,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      // end email
                      const SizedBox(
                        height: 15,
                      ),
                      // password
                      TextFormField(
                        obscureText: _secureText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: showSecure,
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.2),
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // controller: txtpassword,
                        onSaved: (e) => txtpassword = e!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      // end password

                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const <Widget>[
                          Text(
                            "forgot password ?",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      // end text forgot

                      const SizedBox(
                        height: 15,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () {
                            _check();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "I don't have an account yet ?",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "create account",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.sigIn:
        return HomePages(signOut: signOut);
        break;
    }
  }
}
