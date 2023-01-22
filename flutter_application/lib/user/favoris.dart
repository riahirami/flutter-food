import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/user/list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../admin/list.dart';

void main() {
  runApp(ListFavUser());
}

class ListFavUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add new item to menu';
    return MaterialApp(
        title: 'Flutter App Learning',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            body: MyHomePage(),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                if (value == 0)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListViewUser()));
                if (value == 1)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListFavUser()));
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'list',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'favoris',
                ),
              ],
            )));
  }
}

unsetFav(id) async {
  var res = await http
      .put(Uri.parse('http://localhost:5000/produits/notfavoris/$id'));

  if (res.statusCode == 200) {
    // return jsonDecode(res.body);
    getFav();
  }
}

getFav() async {
  var res =
      await http.get(Uri.parse('http://localhost:5000/produits/fav/lists'));

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
          title: Text("Favorit list"),
        ),
        body: Center(
          child: FutureBuilder(
            future: getFav(),
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
                                'https://previews.123rf.com/images/olgastrelnikova/olgastrelnikova1901/olgastrelnikova190100001/115903194-food-icon-with-smile-label-for-food-company-grocery-store-icon-vector-illustration-with-smiling-mout.jpg'),
                          ),
                          title: Text(snapshot.data[index]['titre']),
                          subtitle: Text(snapshot.data[index]['description']),
                          trailing: IconButton(
                              icon: Icon(Icons.favorite),
                              color: Color.fromARGB(255, 235, 4, 8),
                              onPressed: () => {
                                    unsetFav(snapshot.data[index]["_id"]),
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text("Removing !"),
                                              content:
                                                  Text("Item removed from fav"),
                                              actions: [
                                                TextButton(
                                                    child: Text("ok"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            )),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListFavUser()))
                                  }),
                        ),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
