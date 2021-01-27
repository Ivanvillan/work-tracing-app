import 'package:flutter/material.dart';
import 'package:malatesta_app/home/domain_list.dart';
import 'package:malatesta_app/home/insurance_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IfInsurance extends StatefulWidget {
  @override
  _IfInsuranceState createState() => _IfInsuranceState();
}

class _IfInsuranceState extends State<IfInsurance> {
  bool checkYes = false;
  bool checkNot = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Seguro del cliente'),
            backgroundColor: Color(0xff128f39),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context))),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '¿POSEE SEGURO?',
                    style: TextStyle(color: Color(0xffec1c24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.check_circle),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Sí'),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
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
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (checkNot == true && checkYes == false) {
              final idInsurance = null;
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              localStorage.setString('idInsurance', idInsurance);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DomainList(
                            paramDomain: 1,
                          )));
            } else if (checkNot == false && checkYes == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InsuranceList(
                            paramInsurance: 1,
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
}
