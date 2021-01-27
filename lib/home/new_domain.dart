import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/domain_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewDomain extends StatefulWidget {
  final inheritDomain;
  NewDomain({Key key, @required this.inheritDomain}) : super(key: key);
  @override
  _NewDomainState createState() => _NewDomainState();
}

class _NewDomainState extends State<NewDomain> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List data = List();
  bool loading = false;
  String _mySelection;

  final TextEditingController domainController = new TextEditingController();
  final TextEditingController colorController = new TextEditingController();

  @override
  void initState() {
    getVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Nuevo dominio'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.format_indent_increase),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: DropdownButton(
                                hint: Text('Select. Vehículo'),
                                items: data.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(
                                        '${item["brand"]} ${item["model"]} ${item["year"]}'),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  print(newVal);
                                  setState(() {
                                    _mySelection = newVal;
                                  });
                                },
                                value: _mySelection,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.view_module),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: domainController,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese Dominio'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.format_indent_increase),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: colorController,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration:
                                    InputDecoration(labelText: 'Ingrese Color'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Aviso'),
                content: Text('¿Crear dominio?'),
                actions: [
                  FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/malatesta-api/public/index.php/domains/save';
                        var response = await http.post(url, headers: {
                          'Accept': 'application/json',
                          'Cookie': cookies
                        }, body: {
                          "domain": domainController.text,
                          "vehicle_id": _mySelection.toString(),
                          "color": colorController.text,
                        });
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DomainList(
                                paramDomain: widget.inheritDomain,
                              ),
                            ),
                          );
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Dominio creado'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Error al crear'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        Navigator.pop(c, false);
                      }),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  Future<String> getVehicles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/vehicles/get/all/all/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
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
}
