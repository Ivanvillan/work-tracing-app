import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:malatesta_app/home/vehicle_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewVehicle extends StatefulWidget {
  @override
  _NewVehicleState createState() => _NewVehicleState();
}

class _NewVehicleState extends State<NewVehicle> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var loading = false;

  final TextEditingController brandController = new TextEditingController();
  final TextEditingController modelController = new TextEditingController();
  final TextEditingController yearController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Datos del vehiculo'),
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
                            Icon(Icons.local_offer),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: brandController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Ingrese marca'),
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
                            Icon(Icons.view_module),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: modelController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese modelo'),
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
                                controller: yearController,
                                keyboardType: TextInputType.datetime,
                                decoration:
                                    InputDecoration(labelText: 'Ingrese año'),
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
                content: Text('¿Crear vehículo?'),
                actions: [
                  FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/malatesta-api/public/index.php/vehicles/create';
                        var response = await http.post(url, headers: {
                          'Accept': 'application/json',
                          'Cookie': cookies
                        }, body: {
                          "brand": brandController.text,
                          "model": modelController.text,
                          "year": yearController.text,
                          "type": 1.toString(),
                        });
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleList(),
                            ),
                          );
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Vehículo Creado'),
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
          child: Icon(Icons.check),
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
}
