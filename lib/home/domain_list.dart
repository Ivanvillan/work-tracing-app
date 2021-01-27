import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/data_vehicle.dart';
import 'package:malatesta_app/home/new_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DomainList extends StatefulWidget {
  final paramDomain;
  DomainList({Key key, @required this.paramDomain}) : super(key: key);
  @override
  _DomainListState createState() => _DomainListState();
}

class _DomainListState extends State<DomainList> {
  List data = List();

  @override
  void initState() {
    getDomains();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de dominios'),
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
            if (widget.paramDomain == 1) {
              return InkWell(
                onTap: () async {
                  final idDomain = data[i]["id"];
                  final idVehicle = data[i]["vehicle_id"];
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();
                  localStorage.setString('idDomain', idDomain);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataVehicle(
                        idVehicle: idVehicle,
                        paramVehicle: 1,
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
                            Text(data[i]["domain"] ?? 'N/A'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(data[i]["color"] ?? 'N/A'),
                              ]),
                        ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(data[i]["domain"] ?? 'N/A'),
                          Text(data[i]["color"] ?? 'N/A'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: RaisedButton(
                              onPressed: () {
                                final idVehicle = data[i]["vehicle_id"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DataVehicle(
                                      idVehicle: idVehicle,
                                      paramVehicle: 0,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Ver'),
                            ),
                          ),
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
                builder: (context) => NewDomain(
                  inheritDomain: widget.paramDomain,
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

  Future<String> getDomains() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/domains/get'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
