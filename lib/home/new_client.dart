import 'package:flutter/material.dart';
import 'package:malatesta_app/home/client_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewClient extends StatefulWidget {
  final inheritClient;
  NewClient({Key key, @required this.inheritClient}) : super(key: key);
  @override
  _NewClientState createState() => _NewClientState();
}

class DocumentType {
  int id;
  String name;

  DocumentType(this.id, this.name);

  static List<DocumentType> getDocument() {
    return <DocumentType>[
      DocumentType(1, 'DNI'),
    ];
  }
}

class _NewClientState extends State<NewClient> {
  List<DocumentType> _documentType = DocumentType.getDocument();
  List<DropdownMenuItem<DocumentType>> _dropdownMenuItems;
  DocumentType _selectedDocumentType;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var loading = false;
  bool _checked = false;
  int active;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController lastnameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController documentController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_documentType);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Informacion del cliente'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 + 20,
                          child: TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            decoration:
                                InputDecoration(labelText: 'Ingrese nombre'),
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
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person_outline),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 + 20,
                          child: TextFormField(
                            controller: lastnameController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            decoration:
                                InputDecoration(labelText: 'Ingrese apellido'),
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
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.mail),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 + 20,
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                InputDecoration(labelText: 'Ingrese email'),
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
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 + 20,
                          child: TextFormField(
                            controller: addressController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration:
                                InputDecoration(labelText: 'Ingrese direccion'),
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
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.phone),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 + 20,
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration:
                                InputDecoration(labelText: 'Ingrese teléfono'),
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
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Container(
                        //   width: MediaQuery.of(context).size.width / 6,
                        //   child: DropdownButtonHideUnderline(
                        //     child: DropdownButton(
                        //       hint: Text('Tipo'),
                        //       value: _selectedDocumentType,
                        //       items: _dropdownMenuItems,
                        //       onChanged: onChangeDropdownItem,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10.0,
                        // ),
                        Icon(Icons.format_indent_increase),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 + 20,
                          child: TextFormField(
                            controller: documentController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Documento'),
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
                    width: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 + 20,
                      child: CheckboxListTile(
                        title: Text('¿Cliente activo?'),
                        controlAffinity: ListTileControlAffinity.leading,
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xff24CE68),
                        value: _checked,
                        onChanged: (bool value) {
                          setState(() {
                            _checked = value;
                            isActive();
                            print(_checked);
                            print(active);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Aviso'),
                content: Text('¿Crear cliente?'),
                actions: [
                  FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/malatesta-api/public/index.php/persons/save/clients';
                        var response = await http.post(url, headers: {
                          'Accept': 'application/json',
                          'Cookie': cookies
                        }, body: {
                          "name": nameController.text,
                          "last_name": lastnameController.text,
                          "email": emailController.text,
                          "phone": phoneController.text,
                          "address": addressController.text,
                          "document_type": 'DNI',
                          "document": documentController.text,
                          "active": active.toString()
                        });
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Cliente creado'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientList(
                                paramClient: widget.inheritClient,
                              ),
                            ),
                          );
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Error al crear'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        Navigator.pop(c, false);
                      }),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Color(0xffe63c13),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<DocumentType>> buildDropdownMenuItems(
      List documentTypes) {
    List<DropdownMenuItem<DocumentType>> items = List();
    for (DocumentType documentType in documentTypes) {
      items.add(
        DropdownMenuItem(
          value: documentType,
          child: Text(documentType.name),
        ),
      );
    }
    return items;
  }

  isActive() {
    if (_checked == true) {
      active = 1;
    } else {
      active = 0;
    }
  }

  onChangeDropdownItem(DocumentType selectedDocumentType) {
    if (!mounted) return;
    setState(() {
      _selectedDocumentType = selectedDocumentType;
    });
  }

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
}
