import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:malatesta_app/home/client_edit.dart';
import 'package:malatesta_app/home/home.dart';
import 'package:malatesta_app/home/insurance_list.dart';
import 'package:malatesta_app/home/new_client.dart';
import 'package:malatesta_app/home/show_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ClientList extends StatefulWidget {
  final paramClient;
  ClientList({Key key, @required this.paramClient}) : super(key: key);
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  List data = List();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var iduser;
  var state;

  @override
  void initState() {
    getClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Listado de clientes'),
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
            if (data[i]['active'] == "1") {
              state = 'Activo';
            } else {
              state = 'Inactivo';
            }
            if (widget.paramClient == 1) {
              return InkWell(
                onTap: () async {
                  final idClient = data[i]["id"];
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();
                  localStorage.setString('idClient', idClient);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsuranceList(
                        paramInsurance: 1,
                      ),
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
                            Text('${data[i]["name"]} ' ?? 'N/A'),
                            Text(data[i]["last_name"] ?? 'N/A')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(data[i]["email"] ?? 'N/A'),
                              ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(data[i]["phone"] ?? 'N/A'),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(data[i]["address"] ?? 'N/A'),
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
                                    builder: (context) => ShowClient(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(data[i]["phone"] ?? 'N/A'),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(data[i]["address"] ?? 'N/A'),
                              ],
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: () {
                                final id = data[i]["id"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClienEdit(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(state),
                            ],
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: () async {
                                final id = data[i]["id"];
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                var cookies = localStorage.getString('cookies');
                                var url =
                                    'http://200.105.69.227/malatesta-api/public/index.php/persons/clients/change/$id';
                                var response = await http.post(url, headers: {
                                  'Accept': 'application/json',
                                  'Cookie': cookies
                                });
                                print(response);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClientList(
                                      paramClient: 0,
                                    ),
                                  ),
                                );
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Cambio de estado'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Text('Estado'),
                            ),
                          )
                        ],
                      )
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
                builder: (context) => NewClient(
                  inheritClient: widget.paramClient,
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

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<String> getClient() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/persons/get/clients'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
