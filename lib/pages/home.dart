import 'package:androidfull2/api/apiconfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum HomeStatus {
  notVerify,
  verify,
}

class HomePages extends StatefulWidget {
  final VoidCallback signOut;
  const HomePages({
    Key? key,
    required this.signOut,
  }) : super(key: key);

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  singOut() {
    setState(() {
      widget.signOut();
    });
  }

  String name = "", email = "", token = "";
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name").toString();
      email = preferences.getString("email").toString();
      token = preferences.getString("token").toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  // _checklogin() async {
  //   final response =
  //       await http.get(Uri.parse(ApiConfig.apiUrl() + "me"), headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json'
  //   });
  //   if (response.statusCode == 200) {
  //     print("oktdata");
  //   } else {
  //     setState(() {
  //        widget.signOut();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "hello : $name",
            ),
            Text("email : $email"),
            Text("token : $token"),
            // GestureDetector(
            //   onTap: () {
            //     _checklogin();
            //   },
            //   child: const Text("cek"),
            // ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () {
                singOut();
              },
              child: const Text("sigout"),
            ),
          ],
        ),
      ),
    );
  }
}
