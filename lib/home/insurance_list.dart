import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/data_insurance.dart';
import 'package:malatesta_app/home/insurance_edit.dart';
import 'package:malatesta_app/home/new_insurance.dart';
import 'package:http/http.dart' as http;
import 'package:malatesta_app/home/show_insurance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsuranceList extends StatefulWidget {
  final paramInsurance;
  InsuranceList({Key key, @required this.paramInsurance}) : super(key: key);
  @override
  _InsuranceListState createState() => _InsuranceListState();
}

class _InsuranceListState extends State<InsuranceList> {
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
          title: Text('Listado de seguros'),
          backgroundColor: Color(0xff128f39),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.search),
            )
          ],
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            if (widget.paramInsurance == 1) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final idInsurance = data[i]['id'];
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      localStorage.setString('idInsurance', idInsurance);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DataInsurance(idInsurance: idInsurance),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('${data[i]['name']} ' ?? 'N/A'),
                                Text(data[i]['branch_office'] ?? 'N/A'),
                              ],
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('${data[i]['name']}' ?? 'N/A'),
                              Text(data[i]['branch_office'] ?? 'N/A'),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    final id = data[i]['id'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowInsurance(
                                          id: id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Ver'),
                                ),
                              ),
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    final id = data[i]['id'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InsuranceEdit(
                                          id: id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Editar'),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewInsurance(
                  inheritInsurance: widget.paramInsurance,
                ),
              ),
            );
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<String> getInsurance() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/insurances/get'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
