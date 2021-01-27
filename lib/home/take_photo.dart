import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malatesta_app/home/send_pdf.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Future<File> file;
  File tmpFile;
  String errMessage = 'Error al subir imagen';
  String status = '';
  var id;
  bool loading = false;

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3 - 60,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error al elegir imagen',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Ninguna imagen seleccionada',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  void initState() {
    newOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tomar foto del vehículo'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  chooseImageShot();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 + 40,
                  height: MediaQuery.of(context).size.height / 3 + 40,
                  child: Image(image: AssetImage('assets/img/camara.png')),
                ),
              ),
              Text('En caso de hallar daños en'),
              Text('la carrocería, tomar fotos'),
              SizedBox(height: 15.0),
              showImage(),
              loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : RaisedButton(
                      onPressed: () {
                        startUpload();
                      },
                      child: Text('Subir foto'),
                    )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SendPDF(
                  id: id,
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

  chooseImageShot() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  newOrder() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    var cookies = localStorage.getString('cookies');
    var idClient = localStorage.getString('idClient');
    var idInsurance = localStorage.getString('idInsurance');
    var idDomain = localStorage.getString('idDomain');
    var idResp = localStorage.getString('idResp');
    var crystal = localStorage.getString('crystal');
    var nroOrder = localStorage.getString('nroOrder');
    var parameter = localStorage.getString('parameter');
    var url =
        'http://200.105.69.227/malatesta-api/public/index.php/orders/create/$parameter';
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Cookie': cookies
    }, body: {
      "order_nro": nroOrder.toString(),
      "client_id": idClient.toString(),
      "insurance_id": idInsurance.toString(),
      "domain_id": idDomain.toString(),
      "responsable_id": idResp.toString(),
      "metadata": crystal.toString(),
      "state": 1.toString(),
      "admission_date": formattedDate.toString()
    });
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      localStorage.remove('idClient');
      localStorage.remove('idInsurance');
      localStorage.remove('parameter');
      localStorage.remove('idDomain');
      localStorage.remove('idResp');
      localStorage.remove('crystal');
      localStorage.remove('nroOrder');
      id = body;
    } else {
      print('Error');
    }
  }

  upload(String fileName) async {
    setState(() {
      loading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    Map<String, String> headers = {'Cookie': cookies};
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(tmpFile.openRead()));
    var length = await tmpFile.length();
    var uri = Uri.parse(
        'http://200.105.69.227/malatesta-api/public/index.php/orders/image/$id/before');
    final multipartRequest = new http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(http.MultipartFile("picture[]", stream, length,
        filename: basename(tmpFile.path),
        contentType: MediaType('image', 'png')));
    var response = await multipartRequest.send();
    print(response.statusCode);
    print(response.headers);
    print(response.request);
    if (response.statusCode == 200) {
      tmpFile = null;
      fileName = '';
    }
    setState(() {
      loading = false;
    });
  }
}
