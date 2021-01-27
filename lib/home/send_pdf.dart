import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malatesta_app/home/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendPDF extends StatefulWidget {
  final id;
  SendPDF({Key key, @required this.id}) : super(key: key);
  @override
  _SendPDFState createState() => _SendPDFState();
}

class _SendPDFState extends State<SendPDF> {
  var loading = false;
  List data = List();
  List data2 = List();

  @override
  void initState() {
    getOrders();
    getPicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Enviar comprobante'),
          backgroundColor: Color(0xff128f39),
          automaticallyImplyLeading: true,
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 40,
                  height: MediaQuery.of(context).size.height / 2,
                  child:
                      Image(image: AssetImage('assets/img/send_mail_pdf.png')),
                ),
                Container(
                  width: MediaQuery.of(context).size.height / 2,
                  height: MediaQuery.of(context).size.height / 16,
                  child: Text('Enviar comprobante vía Mail o Imprimir'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () async {
                          writeOnPdf();
                          await savePdf();
                          await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                pdf.save(),
                          );
                        },
                        child: Text('Imprimir'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          sendMail();
                        },
                        child: Text('Enviar mail'),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  state: 'all',
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

  final pdf = pw.Document();

  writeOnPdf() {
    var rn = data[0]['nameR'] ?? 'N/A';
    var ra = data[0]['last_nameR'] ?? 'N/A';
    var rd = data[0]['documentR'] ?? 'N/A';
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Text(
                  "COMPROBANTE DE ${data[0]['work_type']} DE CRISTAL | ORDEN NRO. ${data[0]['order_nro']} | FECHA  ${data[0]['admission_date']}")),
          pw.Paragraph(
              text:
                  "Cliente ${data[0]['nameC']} ${data[0]['last_nameC']} - Documento ${data[0]['documentC']}"),
          pw.Paragraph(
              text:
                  "Vehículo ${data[0]['brand']} ${data[0]['model']} - AÑO ${data[0]['year']} - Dominio ${data[0]['domain']}"),
          pw.Paragraph(
              text:
                  "Seguro ${data[0]['nameI']} - Sucursal ${data[0]['branch_office']}"),
          pw.Paragraph(text: "Responsable $rn $ra - Documento $rd"),
          pw.Paragraph(text: "Cristal/es ${data[0]['metadata']}")
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    print(documentPath);

    file.writeAsBytesSync(pdf.save());
  }

  sendMail() async {
    var rn = data[0]['nameR'] ?? 'N/A';
    var ra = data[0]['last_nameR'] ?? 'N/A';
    var rd = data[0]['documentR'] ?? 'N/A';
    final Email email = Email(
      body:
          'Cliente ${data[0]['nameC']} ${data[0]['last_nameC']} - Documento ${data[0]['documentC']} | Vehículo ${data[0]['brand']} ${data[0]['model']} - AÑO ${data[0]['year']} - Dominio ${data[0]['domain']} | Vehículo ${data[0]['brand']} ${data[0]['model']} - AÑO ${data[0]['year']} - Dominio ${data[0]['domain']} | Seguro ${data[0]['nameI']} - Sucursal ${data[0]['branch_office']} | Responsable $rn $ra - Documento $rd | Cristal/es ${data[0]['metadata']}',
      subject:
          'COMPROBANTE DE ${data[0]['work_type']} DE CRISTAL | ORDEN NRO. ${data[0]['order_nro']} | FECHA  ${data[0]['admission_date']}',
      recipients: ['${data[0]['emailC']}'],
      // attachmentPaths: [
      //   'http://200.105.69.227/malatesta-api/uploads/'
      //       '${data2[0]['name']}',
      // ],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  Future<String> getOrders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/orders/get/all/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }

  Future<String> getPicture() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/malatesta-api/public/index.php/orders/pictures/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
