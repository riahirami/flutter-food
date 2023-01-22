import 'package:flutter/material.dart';
import 'package:flutter_application/admin/add.dart';
import 'package:flutter_application/admin/admin-dashboard.dart';
import 'package:flutter_application/admin/list.dart';
import 'package:flutter_application/admin/listusers.dart';
import 'package:flutter_application/user/favoris.dart';
import 'package:flutter_application/user/list.dart';
import 'package:flutter_application/welcome.dart';
import 'package:flutter_application/login.dart';
import 'package:flutter_application/register.dart';

import 'user/user-dashboard.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
    routes: {
      'welcome': (context) => WelcomeScreen(),
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'listuser': (context) => ListViewUser(),
      'listfavuser': (context) => ListFavUser(),
      'listviewadmin': (context) => ListViewAdmin(),
      'admindashboard': (context) => AdminDash(),
      'userdashboard': (context) => UserDash(),
      'AddMenu': (context) => Add(),
      'listusers': (context) => ListUsers(),
    },
  ));
}
