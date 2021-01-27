import 'package:flutter/material.dart';
import 'package:malatesta_app/home/domain_list.dart';
import 'package:url_launcher/url_launcher.dart';

class CallInsurance extends StatefulWidget {
  final insuranceName;
  final insuranceCall;
  CallInsurance(
      {Key key, @required this.insuranceCall, @required this.insuranceName})
      : super(key: key);
  @override
  _CallInsuranceState createState() => _CallInsuranceState();
}

class _CallInsuranceState extends State<CallInsurance> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Llamar al seguro'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 40,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image(image: AssetImage('assets/img/cellphone.png')),
                ),
                InkWell(
                  onTap: () {
                    _launchURL('tel://${widget.insuranceCall}');
                  },
                  child: Column(
                    children: <Widget>[
                      Text('Llamar a:'),
                      Text(widget.insuranceName)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DomainList(
                  paramDomain: 1,
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

  _launchURL(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }
}
