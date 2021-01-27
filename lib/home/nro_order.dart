import 'package:flutter/material.dart';
import 'package:malatesta_app/home/client_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NroOrder extends StatefulWidget {
  @override
  _NroOrderState createState() => _NroOrderState();
}

class _NroOrderState extends State<NroOrder> {
  final TextEditingController numberController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Número de orden'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Numero de orden'),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 20,
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Ingrese número'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Rellenar el campo';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var nroOrder = numberController.text;
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.setString('nroOrder', nroOrder);
            print(nroOrder);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientList(
                  paramClient: 1,
                ),
              ),
            );
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
