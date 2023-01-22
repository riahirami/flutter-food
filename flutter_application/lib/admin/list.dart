import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/admin/add.dart';
import 'package:flutter_application/admin/listusers.dart';
import 'package:flutter_application/user/favoris.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ListViewAdmin());
}

class ListViewAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add new item to menu';

    return MaterialApp(
      title: 'Flutter App Learning',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ListUsers()));
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
          )),
    );
  }
}

getMenu() async {
  var res = await http.get(Uri.parse('http://localhost:5000/produits'));

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder(
            future: getMenu(),
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
                                  'https://cdn-icons-png.flaticon.com/512/1532/1532716.png'),
                            ),
                            title: Text(snapshot.data[index]['titre']),
                            subtitle: Text(snapshot.data[index]['description']),
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    confirmDelete(snapshot.data[index]["_id"])),
                          ));
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(Icons.add),
          backgroundColor: Colors.amberAccent,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Add()));
          },
        ));
  }

  confirmDelete(id) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("delete"),
              content: Text("you confirm removing this item ?"),
              actions: [
                TextButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    http.delete(
                        Uri.parse("http://localhost:5000/produits/$id"));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListViewAdmin()));
                  },
                ),
                TextButton(
                    child: Text("Annuler"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ));
  }
}
