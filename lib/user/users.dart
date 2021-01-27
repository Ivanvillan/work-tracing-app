import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/home.dart';
import 'package:malatesta_app/home/user_edit.dart';
import 'package:malatesta_app/user/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListUser extends StatefulWidget {
  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  List data = List();
  var iduser;
  var stateuser;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de usuarios'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(
                    state: 'all',
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.search),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            iduser = data[i]["id"];
            stateuser = data[i]["enabled"];
            var status;
            if (stateuser == '0') {
              status = 'Inactivo';
            } else {
              status = 'Activo';
            }
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('${data[i]["name"]} ' ?? 'N/A'),
                            Text(data[i]["surname"] ?? 'N/A'),
                          ],
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              final id = data[i]["id"];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEdit(
                                    id: id,
                                  ),
                                ),
                              );
                            },
                            child: Text('Editar'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(data[i]["email"] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('$status' ?? 'N/A'),
                          Text(data[i]['phone'] ?? 'N/A'),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: () async {
                                final id = iduser;
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                var cookies = localStorage.getString('cookies');
                                var url =
                                    'http://200.105.69.227/malatesta-api/public/index.php/users/disabled/$id';
                                var response = await http.post(url, headers: {
                                  'Accept': 'application/json',
                                  'Cookie': cookies
                                });
                                print(response.statusCode);
                                print(response.body);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListUser(),
                                  ),
                                );
                              },
                              child: Text('Estado'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Register(),
              ),
            );
          },
          elevation: 4,
          backgroundColor: Color(0xffe63c13),
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  Future<String> getUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/users/get/all/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
