import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malatesta_app/home/client_list.dart';
import 'package:malatesta_app/home/domain_list.dart';
import 'package:malatesta_app/home/insurance_list.dart';
import 'package:malatesta_app/home/new_client.dart';
import 'package:malatesta_app/home/new_domain.dart';
import 'package:malatesta_app/home/new_insurance.dart';
import 'package:malatesta_app/home/new_responsible.dart';
import 'package:malatesta_app/home/new_vehicle.dart';
import 'package:malatesta_app/home/nro_order.dart';
import 'package:malatesta_app/home/show_order.dart';
import 'package:malatesta_app/home/responsible_list.dart';
import 'package:malatesta_app/home/vehicle_list.dart';
import 'package:malatesta_app/user/login.dart';
import 'package:malatesta_app/user/register.dart';
import 'package:malatesta_app/user/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final state;
  Home({Key key, @required this.state}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String username;
  String email;
  var id;
  var role;
  List data = List();

  _handleDrawer() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    id = localStorage.getString('id');
    var res = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/users/get/all/all/$id'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var resBody = json.decode(res.body);
    setState(() {
      username = localStorage.getString('username');
      email = localStorage.getString('email');
      role = resBody['result'][0]['role'];
      if (role == '1') {
        role = 'Administrador';
      } else if (role == '2') {
        role = 'Usuario';
      } else {
        role = 'Invitado';
      }
    });
    scaffoldKey.currentState.openDrawer();
  }

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Aviso'),
          content: Text('¿Quiere salir de la aplicación?'),
          actions: [
            FlatButton(
              child: Text('Si'),
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Listado de órdenes'),
            backgroundColor: Color(0xff128f39),
            automaticallyImplyLeading: true,
            leading:
                IconButton(icon: Icon(Icons.menu), onPressed: _handleDrawer),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/img/man.png',
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(username.toString() != null
                                    ? username.toString()
                                    : ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(email.toString() != null
                                    ? email.toString()
                                    : ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(role.toString() != null
                                    ? role.toString()
                                    : ''),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 30.0,
                              child: RaisedButton(
                                onPressed: () {
                                  logout();
                                },
                                child: Text('Salir'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text("Órdenes de trabajo"),
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                state: 1,
                              ),
                            ),
                          );
                        },
                        child: Text('Pendientes'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                state: 2,
                              ),
                            ),
                          );
                        },
                        child: Text('En proceso'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                state: 3,
                              ),
                            ),
                          );
                        },
                        child: Text('Realizadas'),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Clientes y Responsables"),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClientList(
                                    paramClient: 0,
                                  ),
                                ),
                              );
                            },
                            child: Text('Admin. Client.'),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResponsibleList(
                                    paramResponsible: 0,
                                  ),
                                ),
                              );
                            },
                            child: Text('Admin. Resp.'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewClient(
                                    inheritClient: 0,
                                  ),
                                ),
                              );
                            },
                            child: Text('Nuevo Client.'),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewResponsible(
                                    inheritResponsible: 0,
                                  ),
                                ),
                              );
                            },
                            child: Text('Nuevo Resp.'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Seguros"),
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsuranceList(
                                paramInsurance: 0,
                              ),
                            ),
                          );
                        },
                        child: Text('Administrar'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewInsurance(
                                inheritInsurance: 0,
                              ),
                            ),
                          );
                        },
                        child: Text('Nuevo Seguro'),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Dominios y Vehículos"),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DomainList(
                                    paramDomain: 0,
                                  ),
                                ),
                              );
                            },
                            child: Text('Admin. Domin.'),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VehicleList(),
                                ),
                              );
                            },
                            child: Text('Admin. Vehíc.'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewDomain(
                                    inheritDomain: 0,
                                  ),
                                ),
                              );
                            },
                            child: Text('Nuevo Dominio'),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewVehicle(),
                                ),
                              );
                            },
                            child: Text('Nuevo Vehículo'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Usuarios"),
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          if (role == 'Administrador') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListUser(),
                              ),
                            );
                          } else {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Acceso no concedido'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text('Administrar'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          if (role == 'Administrador') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          } else {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Acceso no concedido'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text('Nuevo Usuario'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              var state = data[i]['state'];
              var colorState;
              if (state == '1') {
                colorState = Colors.redAccent;
              } else if (state == '2') {
                colorState = Colors.amber;
              } else {
                colorState = Color(0xff128f39);
              }
              return InkWell(
                onTap: () {
                  var id = data[i]['idO'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderShow(
                        id: id,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Órden ${data[i]['order_nro']}' ?? 'N/A'),
                            Text(data[i]['admission_date'] != null
                                ? data[i]['admission_date']
                                    .toString()
                                    .substring(0, 16)
                                : '')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(data[i]['work_type'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('${data[i]['brand']} | ' ?? 'N/A'),
                                Text('${data[i]['model']} | ' ?? 'N/A'),
                                Text('${data[i]['domain']}' ?? 'N/A'),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.0),
                                    color: colorState,
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
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
                  builder: (context) => NroOrder(),
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

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var id = localStorage.getString('id');
    var url =
        'http://200.105.69.227/malatesta-api/public/index.php/users/logout';
    var response = await http.post(url,
        headers: {'Accept': 'application/json', 'Cookie': cookies},
        body: {"id": id.toString()});
    print(response.body);
    if (response.statusCode == 200) {
      localStorage.remove('cookies');
      localStorage.remove('role');
      localStorage.remove('email');
      localStorage.remove('username');
      localStorage.remove('id');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Error al cerrar sesión'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<String> getOrders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    final state = widget.state;
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/orders/get/$state'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });

    return "Sucess";
  }
}
