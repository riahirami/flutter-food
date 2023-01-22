import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/admin/admin-dashboard.dart';
import 'package:flutter_application/user/favoris.dart';
import 'package:flutter_application/user/user-dashboard.dart';
import 'register.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class DataRequiredForBuild {
  final String role;
  final String email;
  final String password;

  const DataRequiredForBuild({
    required this.role,
    required this.password,
    required this.email,
  });

  factory DataRequiredForBuild.fromJson(Map<String, dynamic> json) {
    return DataRequiredForBuild(
        role: json['role'], password: json['password'], email: json['email']);
  }
}

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

Future<DataRequiredForBuild> logUser() async {
  var res = await http.post(
    Uri.parse('http://localhost:5000/auth'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': _controllerEmail.text,
      'password': _controllerPassword.text,
      'role': 'true'
    }),
  );

  if (res.statusCode == 201) {
    return DataRequiredForBuild.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to login.');
  }
}

getUsers() async {
  var users = await http.get(Uri.parse('http://localhost:5000/utilisateur'));

  return (jsonDecode(users.body));
}

setUser(email, password, role) async {
  var users = await http.post(
    Uri.parse("http://localhost:5000/auth"),
    body: jsonEncode({'email': email, 'password': password, 'isAdmin': role}),
  );
  return jsonDecode(users.body);

  //return User.fromJson(jsonDecode(users.body));
}

Future<String> checkRole(mail) async {
  //checkUser();
  var res = await http.get(Uri.parse(
      'http://localhost:5000/users/utilisateur/checkadminbyemail/$mail'));
  var data = jsonDecode(res.body);
  String isAdmin = data['isAdmin'];
  String finalData = isAdmin.toString();
  print(finalData);
  return finalData.toString();
  // if (jsonDecode(res.body) == "true") {
  //   return "true";
  // } else {
  //   return "false";
  // }
}

final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();

class _MyLoginState extends State<MyLogin> {
  final _formKey = GlobalKey<FormState>();
  Future<DataRequiredForBuild>? _futureMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Text(
              'Welcome',
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
            Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.only(left: 35, top: 130),
                  child: FutureBuilder(
                      future: checkRole(_controllerEmail.text),
                      // future: getUsers(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return ListView.builder(
                            // itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 35, right: 35),
                                    child: Column(
                                      children: [
                                        TextField(
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              hintText: "Email",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          controller: _controllerEmail,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TextField(
                                          style: TextStyle(),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              hintText: "Password",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          controller: _controllerPassword,
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Sign in',
                                              style: TextStyle(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  Color(0xff4c505b),
                                              child: IconButton(
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    setState(() {
                                                      //  print(snapshot.data);
                                                      // var role = checkRole(
                                                      //     _controllerEmail
                                                      //         .text);
                                                      // setUser(
                                                      //     _controllerEmail.text,
                                                      //     _controllerPassword
                                                      //         .text,
                                                      //     role);
                                                    });
                                                    var role = checkRole(
                                                        _controllerEmail.text);
                                                    // print(snapshot.data[index]
                                                    //     ['email']);
                                                    (role == "true")
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AdminDash()))
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UserDash()));

                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             MyRegister()));
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_forward,
                                                  )),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, 'register');
                                              },
                                              child: Text(
                                                'Sign Up',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(0xff4c505b),
                                                    fontSize: 18),
                                              ),
                                              style: ButtonStyle(),
                                            ),
                                            TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Forgot Password',
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(0xff4c505b),
                                                    fontSize: 18,
                                                  ),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      })),
            )
          ],
        ),
      ),
    );
  }
}
