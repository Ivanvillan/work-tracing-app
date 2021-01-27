import 'package:flutter/material.dart';
import 'package:malatesta_app/home/crystal_select.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TypeService extends StatefulWidget {
  @override
  _TypeServiceState createState() => _TypeServiceState();
}

class _TypeServiceState extends State<TypeService> {
  bool check1 = false;
  bool check2 = false;
  var parameter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Tipo de servicio'),
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
                          Icon(Icons.get_app),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Instalación'),
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
                          Icon(Icons.autorenew),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Recambio'),
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
              parameter = 'installation';
              print(parameter);
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              localStorage.setString('parameter', parameter);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CrystalSelect()));
            } else if (check1 == false && check2 == true) {
              parameter = 'replacement';
              print(parameter);
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              localStorage.setString('parameter', parameter);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CrystalSelect()));
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
