import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/show_order.dart';
import 'package:malatesta_app/home/take_photo_after.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ImageCar extends StatefulWidget {
  final id;
  ImageCar({Key key, @required this.id}) : super(key: key);
  @override
  _ImageCarState createState() => _ImageCarState();
}

class _ImageCarState extends State<ImageCar> {
  List data = List();
  @override
  void initState() {
    getPicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fotos de orden'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderShow(
                    id: widget.id,
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePhotoAfter(
                      id: widget.id,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(data[i]['type']),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image.network(
                      'http://200.105.69.227/malatesta-api/uploads/'
                      '${data[i]['name']}'),
                ),
                Divider(
                  color: Colors.black38,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<String> getPicture() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/orders/pictures/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
