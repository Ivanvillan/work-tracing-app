import 'package:flutter/material.dart';
import 'package:malatesta_app/home/retire_car.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrystalSelect extends StatefulWidget {
  @override
  _CrystalSelectState createState() => _CrystalSelectState();
}

class _CrystalSelectState extends State<CrystalSelect> {
  Map<String, bool> numbers = {
    'Parabrisa Delantero': false,
    'Parabrisa Trasero / Luneta': false,
    'Puerta Delantero': false,
    'Aleta': false,
    'Puerta Trassero': false,
    'Vidrio Costado': false,
    'Techo Solar': false,
    'Techo Panoramico': false,
  };

  var holder_1 = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Selección de cristal'),
            backgroundColor: Color(0xff128f39),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context))),
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image(image: AssetImage('assets/img/part_car.jpg')),
            ),
            Expanded(
              child: ListView(
                children: numbers.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: numbers[key],
                    activeColor: Colors.pink,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        numbers[key] = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getItems();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RetireCar()));
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }

  getItems() async {
    numbers.forEach((key, value) {
      if (value == true) {
        holder_1.add(key);
      }
    });

    var crystal = StringBuffer();
    holder_1.forEach((item) {
      crystal.write('·${item.toString()} ');
    });
    print(crystal);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('crystal', crystal.toString());

    holder_1.clear();
  }
}
