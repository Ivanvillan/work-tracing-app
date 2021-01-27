import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/home.dart';
import 'package:malatesta_app/home/image_car.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderShow extends StatefulWidget {
  final id;
  OrderShow({Key key, @required this.id}) : super(key: key);
  @override
  _OrderShowState createState() => _OrderShowState();
}

class _OrderShowState extends State<OrderShow> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List data = List();
  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Datos de la orden'),
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
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            var state = data[i]['state'];
            var tipo = data[i]['work_type'];
            if (state == '1') {
              state = 'Pendiente';
            } else if (state == '2') {
              state = 'En proceso';
            } else {
              state = 'Realizada';
            }
            if (tipo == 'RECAMBIO') {
              tipo = 'replacement';
            } else {
              tipo = 'installation';
            }
            return Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('ORDEN: '),
                                    Text(data[i]['order_nro'] ?? 'N/A'),
                                  ],
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Text(data[i]['egress_date'] != null
                                    ? data[i]['egress_date']
                                        .toString()
                                        .substring(0, 16)
                                    : ''),
                                Container(
                                  width: 70,
                                  height: 20,
                                  child: RaisedButton(
                                    onPressed: () {
                                      var id = data[i]['idO'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageCar(
                                            id: id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Fotos',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Tipo trabajo'),
                                  Text(data[i]['work_type'] ?? 'N/A'),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Estado'),
                                  Text(state ?? 'N/A'),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('CLIENTE: '),
                              Text('${data[i]['nameC']} '
                                      '${data[i]['last_nameC']}' ??
                                  'N/A'),
                            ],
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Direc.'),
                                  Text(data[i]['addresseC'] ?? 'N/A'),
                                ],
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Tel.'),
                                  InkWell(
                                      onTap: () {
                                        _launchURL(
                                            'tel://${data[i]['phoneC']}');
                                      },
                                      child: Text(data[i]['phoneC'] ?? 'N/A')),
                                ],
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Email'),
                                  InkWell(
                                      onTap: () {
                                        _launchURL(
                                            'mailto:${data[i]['emailC']}');
                                      },
                                      child: Text(data[i]['emailC'] ?? 'N/A')),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('VEHÍCULO: '),
                              Text(data[i]['brand'] ?? 'N/A'),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(data[i]['model'] ?? 'N/A'),
                            ],
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Año'),
                                  Text(data[i]['year'] ?? 'N/A'),
                                ],
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Dominio'),
                                  Text(data[i]['domain'] ?? 'N/A'),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('SEGURO: '),
                              Text(data[i]['nameI'] ?? 'N/A'),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(data[i]['branch_office'] ?? 'N/A')
                            ],
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Tel.'),
                                  InkWell(
                                      onTap: () {
                                        _launchURL(
                                            'tel://${data[i]['phoneI']}');
                                      },
                                      child: Text(data[i]['phoneI'] ?? 'N/A')),
                                ],
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Email'),
                                  InkWell(
                                      onTap: () {
                                        _launchURL(
                                            'mailto:${data[i]['emailI']}');
                                      },
                                      child: Text(data[i]['emailI'] ?? 'N/A')),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('RESPONSABLE: '),
                              Text(data[i]['nameR'] ?? 'N/A'),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(data[i]['last_nameR'] ?? 'N/A'),
                            ],
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Direc.'),
                                  Text(data[i]['addressR'] ?? 'N/A'),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Tel.'),
                                  InkWell(
                                      onTap: () {
                                        _launchURL(
                                            'tel://${data[i]['phoneR']}');
                                      },
                                      child: Text(data[i]['phoneR'] ?? 'N/A')),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Email'),
                                  InkWell(
                                      onTap: () {
                                        _launchURL(
                                            'mailto:${data[i]['emailR']}');
                                      },
                                      child: Text(data[i]['emailR'] ?? 'N/A')),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('CRISTALES'),
                            ],
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Text(data[i]['metadata'] ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            if (state == 'Pendiente') {
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              var cookies = localStorage.getString('cookies');
                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd kk:mm').format(now);
                              var url =
                                  'http://200.105.69.227/malatesta-api/public/index.php/orders/create/$tipo';
                              var response = await http.post(url, headers: {
                                'Accept': 'application/json',
                                'Cookie': cookies
                              }, body: {
                                "order_nro": data[i]['order_nro'].toString(),
                                "client_id": data[i]['idC'].toString(),
                                "insurance_id": data[i]['idI'].toString(),
                                "domain_id": data[i]['idD'].toString(),
                                "responsable_id": data[i]['idR'].toString(),
                                "metadata": data[i]['metadata'].toString(),
                                "state": 2.toString(),
                                "admission_date":
                                    data[i]['admission_date'].toString(),
                                "egress_date": formattedDate.toString(),
                                "id": data[i]['idO'].toString()
                              });
                              if (response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderShow(
                                      id: data[i]['idO'],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Error al cambiar de estado'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text('En proceso'),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            if (state == 'Pendiente') {
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              var cookies = localStorage.getString('cookies');
                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd kk:mm').format(now);
                              var url =
                                  'http://200.105.69.227/malatesta-api/public/index.php/orders/create/$tipo';
                              var response = await http.post(url, headers: {
                                'Accept': 'application/json',
                                'Cookie': cookies
                              }, body: {
                                "order_nro": data[i]['order_nro'].toString(),
                                "client_id": data[i]['idC'].toString(),
                                "insurance_id": data[i]['idI'].toString(),
                                "domain_id": data[i]['idD'].toString(),
                                "responsable_id": data[i]['idR'].toString(),
                                "metadata": data[i]['metadata'].toString(),
                                "state": 3.toString(),
                                "admission_date":
                                    data[i]['admission_date'].toString(),
                                "egress_date": formattedDate.toString(),
                                "id": data[i]['idO'].toString()
                              });
                              if (response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderShow(
                                      id: data[i]['idO'],
                                    ),
                                  ),
                                );
                              } else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Error al cambiar de estado'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else if (state == 'En proceso') {
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              var cookies = localStorage.getString('cookies');
                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd kk:mm').format(now);
                              var url =
                                  'http://200.105.69.227/malatesta-api/public/index.php/orders/create/$tipo';
                              var response = await http.post(url, headers: {
                                'Accept': 'application/json',
                                'Cookie': cookies
                              }, body: {
                                "order_nro": data[i]['order_nro'].toString(),
                                "client_id": data[i]['idC'].toString(),
                                "insurance_id": data[i]['idI'].toString(),
                                "domain_id": data[i]['idD'].toString(),
                                "responsable_id": data[i]['idR'].toString(),
                                "metadata": data[i]['metadata'].toString(),
                                "state": 3.toString(),
                                "admission_date":
                                    data[i]['admission_date'].toString(),
                                "egress_date": formattedDate.toString(),
                                "id": data[i]['idO'].toString()
                              });
                              if (response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderShow(
                                      id: data[i]['idO'],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Error al cambiar de estado'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text('Realizado'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
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

  Future<String> getOrders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/orders/get/all/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }

  _launchURL(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }
}
