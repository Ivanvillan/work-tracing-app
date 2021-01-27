import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/insurance_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewInsurance extends StatefulWidget {
  final inheritInsurance;
  NewInsurance({Key key, @required this.inheritInsurance}) : super(key: key);
  @override
  _NewInsuranceState createState() => _NewInsuranceState();
}

class _NewInsuranceState extends State<NewInsurance> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List data = List();
  var loading = false;
  // ignore: unused_field
  var _client;
  var client;
  // ignore: unused_field
  String _mySelection;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController altenativephoneController =
      new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController branchofficeController =
      new TextEditingController();

  @override
  void initState() {
    getClient();
    super.initState();
  }

  void showModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 200,
          alignment: Alignment.center,
          child: ListView.separated(
            itemCount: data == null ? 0 : data.length,
            separatorBuilder: (context, int) {
              return Divider(
                height: 10.0,
              );
            },
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Text(
                  data[i]["name"] != null
                      ? '${data[i]["name"]} ${data[i]["last_name"]}'
                      : 'No hay clientes agregados',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(
                    () {
                      client = data[i]["name"];
                      _mySelection = data[i]["id"];
                      _client = '${data[i]["name"]} ${data[i]["last_name"]} ';
                    },
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Agregar seguro'),
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.security),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: nameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese nombre'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.local_offer),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: branchofficeController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese sucursal'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.mail),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    InputDecoration(labelText: 'Ingrese email'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: addressController,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese direccion'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese teléfono'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.smartphone),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: altenativephoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese teléfono aleternativo'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            color: Color(0xff128f39),
                            textColor: Color(0xffFFFBFB),
                            child: Text(_client != null
                                ? '$_client'
                                : 'Seleccione un cliente'),
                            onPressed: () => showModal(context),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
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
                content: Text('¿Crear seguro?'),
                actions: [
                  FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/malatesta-api/public/index.php/insurances/save';
                        var response = await http.post(url, headers: {
                          'Accept': 'application/json',
                          'Cookie': cookies
                        }, body: {
                          "name": nameController.text,
                          "branch_office": branchofficeController.text,
                          "email": emailController.text,
                          "phone": phoneController.text,
                          "altenative_phone": altenativephoneController.text,
                          "address": addressController.text,
                          "client_id": _mySelection.toString()
                        });
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsuranceList(
                                paramInsurance: widget.inheritInsurance,
                              ),
                            ),
                          );
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Error al editar'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Error'),
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
          child: Icon(
            Icons.check,
            color: Colors.white,
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
