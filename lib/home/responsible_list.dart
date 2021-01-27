import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/home.dart';
import 'package:malatesta_app/home/new_responsible.dart';
import 'package:malatesta_app/home/responsible_edit.dart';
import 'package:malatesta_app/home/retire_car.dart';
import 'package:malatesta_app/home/show_responsible.dart';
import 'package:malatesta_app/home/take_photo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResponsibleList extends StatefulWidget {
  final paramResponsible;
  ResponsibleList({Key key, @required this.paramResponsible}) : super(key: key);
  @override
  _ResponsibleListState createState() => _ResponsibleListState();
}

class _ResponsibleListState extends State<ResponsibleList> {
  List data = List();

  @override
  void initState() {
    getResponsibles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de resp.'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (widget.paramResponsible == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RetireCar(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      state: 'all',
                    ),
                  ),
                );
              }
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
            if (widget.paramResponsible == 1) {
              return InkWell(
                onTap: () async {
                  final idResp = data[i]["id"];
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();
                  localStorage.setString('idResp', idResp);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePhoto(),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(data[i]["name"] ?? 'Sin nombre'),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(data[i]["last_name"] ?? 'Sin apellido')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(data[i]["email"] ?? 'Sin email'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(data[i]["phone"] ?? 'Sin teléfono'),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(data[i]["address"] ?? 'Sin dirección'),
                              ],
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
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
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(data[i]["last_name"] ?? 'N/A')
                            ],
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: () {
                                final id = data[i]["id"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowResponsible(
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Ver'),
                            ),
                          )
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 3.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: <Widget>[
                      //       Text(data[i]["email"] ?? 'Sin email'),
                      //     ],
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(data[i]["phone"] ?? 'N/A'),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(data[i]["address"] ?? 'N/A'),
                            ],
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: () {
                                final id = data[i]["id"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResponsibleEdit(
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Editar'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewResponsible(
                  inheritResponsible: widget.paramResponsible,
                ),
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

  Future<String> getResponsibles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/persons/get/responsibles'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
