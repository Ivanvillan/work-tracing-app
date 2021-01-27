import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/call_insurance.dart';
import 'package:malatesta_app/home/domain_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataInsurance extends StatefulWidget {
  final idInsurance;
  DataInsurance({Key key, @required this.idInsurance}) : super(key: key);
  @override
  _DataInsuranceState createState() => _DataInsuranceState();
}

class _DataInsuranceState extends State<DataInsurance> {
  List data = List();
  bool checkYes = false;
  bool checkNot = false;

  @override
  void initState() {
    getInsuranceById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Datos del seguro'),
            backgroundColor: Color(0xff128f39),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context))),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(data[i]['name']),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text('Teléfono: '),
                      Text(data[i]['phone'] ?? 'N/A')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text('Dirección: '),
                      Text(data[i]['address'] ?? 'N/A')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.mail),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text('Email: '),
                      Text(data[i]['email'] ?? 'N/A')
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text('¿Tiene orden de seguro?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.check_circle),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Si'),
                          ],
                        ),
                        Checkbox(
                          value: checkYes,
                          onChanged: (bool value) {
                            print(value);
                            setState(() {
                              checkYes = value;
                            });
                          },
                          activeColor: Color(0xff128f39),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.remove_circle),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('No'),
                          ],
                        ),
                        Checkbox(
                          value: checkNot,
                          onChanged: (bool value) {
                            print(value);
                            setState(() {
                              checkNot = value;
                            });
                          },
                          activeColor: Color(0xffec1c24),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (checkNot == true && checkYes == false) {
              final insuranceCall = data[0]['phone'];
              final insuranceName = data[0]['name'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallInsurance(
                    insuranceCall: insuranceCall,
                    insuranceName: insuranceName,
                  ),
                ),
              );
            } else if (checkNot == false && checkYes == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DomainList(
                            paramDomain: 1,
                          )));
            } else if (checkNot == false && checkYes == false ||
                checkNot == true && checkYes == true) {
              print('error');
            }
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }

  Future<String> getInsuranceById() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/insurances/get/${widget.idInsurance}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
