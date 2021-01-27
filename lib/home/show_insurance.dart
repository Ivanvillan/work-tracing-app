import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShowInsurance extends StatefulWidget {
  final id;
  ShowInsurance({Key key, @required this.id}) : super(key: key);
  @override
  _ShowInsuranceState createState() => _ShowInsuranceState();
}

class _ShowInsuranceState extends State<ShowInsurance> {
  List data = List();

  @override
  void initState() {
    getInsurance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Información del seguro'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
                      child: Text('DATOS DEL SEGURO',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('NOMBRE',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['name'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('APELLIDO',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['branch_office'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('TELEFONO',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['phone'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('EMAIL',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['email'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('DIRECCION',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['address'] ?? 'N/A'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> getInsurance() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var id = widget.id;
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/insurances/get/$id'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(data);

    return "Sucess";
  }
}
