import 'package:flutter/material.dart';
import 'package:malatesta_app/home/responsible_list.dart';
import 'package:malatesta_app/home/take_photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetireCar extends StatefulWidget {
  @override
  _RetireCarState createState() => _RetireCarState();
}

class _RetireCarState extends State<RetireCar> {
  bool check1 = false;
  bool check2 = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('¿Quien retira el vehículo?'),
            backgroundColor: Color(0xff128f39),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context))),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.vpn_key),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Propietario'),
                        ],
                      ),
                      Checkbox(
                        value: check1,
                        onChanged: (bool value) {
                          print(value);
                          setState(() {
                            check1 = value;
                          });
                        },
                        activeColor: Color(0xff128f39),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.account_box),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Responsable'),
                        ],
                      ),
                      Checkbox(
                        value: check2,
                        onChanged: (bool value) {
                          print(value);
                          setState(() {
                            check2 = value;
                          });
                        },
                        activeColor: Color(0xffec1c24),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (check1 == true && check2 == false) {
              final idResp = '0';
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              localStorage.setString('idResp', idResp);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TakePhoto()));
            } else if (check1 == false && check2 == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResponsibleList(
                            paramResponsible: 1,
                          )));
            } else if (check1 == false && check2 == false ||
                check2 == true && check1 == true) {
              print('error');
            }
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
