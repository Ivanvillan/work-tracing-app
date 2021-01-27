import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/type_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataVehicle extends StatefulWidget {
  final idVehicle;
  final paramVehicle;
  DataVehicle({Key key, @required this.idVehicle, @required this.paramVehicle})
      : super(key: key);
  @override
  _DataVehicleState createState() => _DataVehicleState();
}

class _DataVehicleState extends State<DataVehicle> {
  List data = List();
  bool checkYes = false;
  bool checkNot = false;

  @override
  void initState() {
    getVehicleById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Información del vehículo'),
            backgroundColor: Color(0xff128f39),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context))),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('DATOS DEL VEHICULO',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Marca: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['brand'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Modelo: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['model'] ?? 'N/A')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Año: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['year'] ?? 'N/A')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.paramVehicle == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TypeService(),
                ),
              );
            } else {
              print('edit');
            }
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }

  Future<String> getVehicleById() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/vehicles/getbyid/${widget.idVehicle}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
