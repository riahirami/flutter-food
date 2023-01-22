import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/admin/add.dart';
import 'package:flutter_application/user/favoris.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'list.dart';
import 'listusers.dart';

void main() {
  runApp(ListUsers());
}

class ListUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'list of our item menu';

    return MaterialApp(
        title: 'Flutter App Learning',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Scaffold(
            body: MyHomePage(),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                if (value == 0)
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Add()));
                if (value == 1)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListViewAdmin()));
                if (value == 2)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListUsers()));
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'add',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'list',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.verified_user),
                  label: 'users',
                ),
              ],
            )));
  }
}

getUsers() async {
  var res =
      await http.get(Uri.parse('http://localhost:5000/users/utilisateur'));

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
}

setAdmin(id) async {
  var res =
      await http.put(Uri.parse('http://localhost:5000/users/superadmin/$id'));

  if (res.statusCode == 200) {
    getUsers();
  }
}

unsetAdmin(id) async {
  var res = await http
      .put(Uri.parse('http://localhost:5000/users/revokesuperadmin/$id'));

  if (res.statusCode == 200) {
    getUsers();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images = [
    "assets/images/scenary.jpg",
    "assets/images/scenary_red.jpg",
    "assets/images/waterfall.jpg",
    "assets/images/tree.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Users list"),
        ),
        body: Center(
          child: FutureBuilder(
            future: getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 4,
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 50,
                                minHeight: 50,
                                maxWidth: 70,
                                maxHeight: 70,
                              ),
                              child: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                            ),
                            title: Text(snapshot.data[index]['username']),
                            subtitle: Text(snapshot.data[index]['email']),
                            trailing: snapshot.data[index]['isAdmin'] == "false"
                                ? IconButton(
                                    icon: Icon(Icons.admin_panel_settings),
                                    onPressed: () => {
                                          setAdmin(snapshot.data[index]["_id"]),
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: Text("Added"),
                                                    content: Text(
                                                        "user maked admin"),
                                                    actions: [
                                                      TextButton(
                                                          child: Text("ok"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          })
                                                    ],
                                                  )),
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListUsers()))

                                          // getMenu()
                                        })
                                : IconButton(
                                    icon: Icon(Icons.add_moderator_outlined),
                                    color: Color.fromARGB(255, 6, 112, 26),
                                    onPressed: () => {
                                          unsetAdmin(
                                              snapshot.data[index]["_id"]),
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: Text("revoke admin"),
                                                    content: Text(
                                                        "this users wil lost adminsitration"),
                                                    actions: [
                                                      TextButton(
                                                          child: Text("ok"),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ListUsers()));
                                                          })
                                                    ],
                                                  )),
                                        }),
                          ));
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
