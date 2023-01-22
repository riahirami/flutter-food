import 'dart:convert';
import 'dart:io';
import 'dart:js';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/admin/list.dart';
import 'package:flutter_application/admin/listusers.dart';
import 'package:flutter_application/user/favoris.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Add());

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add new dish to menu';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: MyCustomForm(),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              if (value == 0)
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ListViewAdmin()));
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

Future<Menu> insert(String titre, String description, String prix) async {
  var res = await http.post(
    Uri.parse('http://localhost:5000/produits/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body:
        jsonEncode({'titre': titre, 'description': description, 'prix': prix}),
  );
  print("resultat");
  print(res);
  //return res;
  if (res.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Menu.fromJson(jsonDecode(res.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to add this menu.');
  }
}

class Menu {
  final int id;
  final String titre;
  final String description;
  final int prix;

  const Menu(
      {required this.id,
      required this.titre,
      required this.description,
      required this.prix});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        id: json['id'],
        titre: json['titre'],
        description: json['description'],
        prix: json['prix']);
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  Future<Menu>? _futureMenu;

  final TextEditingController _controllerTitre = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final TextEditingController _controllerPrix = TextEditingController();

  // final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        body: Center(
            child: Column(children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null) {
                  return "the text field can't be empty";
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter dish name',
                labelText: 'Name',
              ),
              controller: _controllerTitre,
            ),
            TextFormField(
              validator: (value) {
                if (value == null) {
                  return "the text field can't be empty";
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.description),
                hintText: 'Enter dish description',
                labelText: 'description',
              ),
              controller: _controllerDesc,
            ),
            TextFormField(
              validator: (value) {
                if (value == null) {
                  return "the text field can't be empty";
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.price_change),
                hintText: 'Enter the price',
                labelText: 'prix',
              ),
              controller: _controllerPrix,
            ),
            new Container(
                padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      _futureMenu = insert(_controllerTitre.text,
                          _controllerDesc.text, _controllerPrix.text);
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListViewAdmin()));
                  },
                  child: const Text('Add'),
                ))
          ],
        ),
      )
    ])));
  }
}
