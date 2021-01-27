import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:malatesta_app/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Aviso'),
          content: Text('¿Quiere salir de la aplicación?'),
          actions: [
            FlatButton(
              child: Text('Si'),
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180.0,
                      child: Image(image: AssetImage('assets/img/auto.jpg')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image(
                            image: AssetImage('assets/img/logo01.png'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 180.0),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          color: Color(0xff128f39),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'INICIO DE SESIÓN',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.mail),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 + 20,
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      labelText: 'Ingrese su email'),
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
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.lock),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese su contraseña'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  loading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            color: Color(0xffe63c13),
                            textColor: Color(0xffffffff),
                            onPressed: () {
                              // if (_formKey.currentState.validate()) {
                              //   Scaffold.of(context).showSnackBar(
                              //       SnackBar(content: Text('Processing Data')));
                              // }
                              login();
                            },
                            child: Text('INGRESAR'),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  var cookies = "";

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  login() async {
    setState(() {
      loading = true;
    });
    var url =
        'http://200.105.69.227/malatesta-api/public/index.php/users/login';
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
    }, body: {
      "email": emailController.text,
      "contrasenia": passwordController.text
    });
    var body = json.decode(response.body);
    if (body['response'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('cookies', response.headers['set-cookie']);
      var url =
          'http://200.105.69.227/malatesta-api/public/index.php/users/state';
      var res = await http.post(url, headers: {
        'Accept': 'application/json',
        'Cookie': response.headers['set-cookie']
      });
      var resbody = json.decode(res.body);
      print(resbody);
      localStorage.setString('username', resbody['result']['user']);
      localStorage.setString('email', resbody['result']['email']);
      localStorage.setString('role', resbody['result']['role']);
      localStorage.setString('id', resbody['result']['ID']);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Has iniciado sesión'),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            state: 'all',
          ),
        ),
      );
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión, comprueba tus datos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }
}
