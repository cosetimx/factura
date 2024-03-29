//import 'dart:core';
import 'dart:io';

import 'Globals.dart' as globals;
import 'components/menu.component.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';
import 'dart:async' show Future, Timer;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_icons/flutter_icons.dart';

String NOMBRE = "";

// Login Data
String passwd = globals.PASSWD;
String USERLIS = globals.USERLIS;
bool vacia = false;

class Consulta {
  String no_guia;
  String status;
  String accion;
  String log;

  Consulta({
    required this.no_guia,
    required this.status,
    required this.accion,
    required this.log,
  });

  factory Consulta.fromJson(Map<String, dynamic> parsedJson) {
    return Consulta(
        no_guia: parsedJson['no_guia'].toString(),
        status: parsedJson['status'],
        accion: parsedJson['accion'] ?? '',
        log: parsedJson['log']);
  }
}

class CunsultaView extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estatus de Factura',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      drawer: XmobeMenu(),
      body: Center(child: CunsultaMap()),
    );
  }
}

class CunsultaMap extends StatefulWidget {
  State<CunsultaMap> createState() => CunsultaState();
}

class CunsultaState extends State<CunsultaMap> {
  TextEditingController NoFact = TextEditingController(text: "");
  TextEditingController controllerDescripcion = TextEditingController(text: "");
  List<Consulta> Factura = [];

  bool validdescripcion = false;
  bool _isLoading = false;
  bool cargado = false;

  //String factura = '';
  HttpClient client = new HttpClient();
  //String descripcion = '';
  String _Estatus = '';
  List Logs = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> _data(String _factura) async {
    _isLoading = true;
    //  Factura = [];
    //  Logs = [];
    String URLs =
        "https://www.halcontracking.com/php/factura/consulta.php?fact=$_factura";

    print(URLs);
    var response = await http.get(Uri.parse(URLs));

    var jsonResponse = json.decode(response.body);

    print("Resultados $jsonResponse");

    if (response.statusCode == 200) {
      if (jsonResponse['success'] == 1) {
        var datos = await jsonResponse['Result'];

        print('Datos $datos');

        Consulta facturaS = Consulta(
            accion: datos[0]['accion'],
            log: datos[0]['log'],
            no_guia: datos[0]['num_guia'],
            status: datos[0]['status']);

        if (facturaS.log != '') {
          Logs = datos[0]['log'].toString().split('|');
        } else {
          Logs = [];
        }

        setState(() {
          Factura.add(facturaS);
          NoFact = TextEditingController(text: "");
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
                title: Text('Atención'),
                content: Text(
                    'Error Folio no Encontrado o mal capturado, Favor de Verificar'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cerrar'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ]);
          });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BotonConsulta = Container(
        height: 105,
        child: Card(
            elevation: 18.0,
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text("Estatus de Factura a Buscar"),
                    subtitle: TextField(
                      controller: NoFact,
                      keyboardType: TextInputType
                          .text, //numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'No. de Factura',
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        NoFact = TextEditingController(text: value);
                      },
                    ),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        iconSize: 18,
                        icon: Icon(
                          Icons.check,
                          color: Colors.teal[800],
                        ),
                        onPressed: () {
                          _data(NoFact.text);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.teal[800],
                        ),
                        iconSize: 18,
                        onPressed: () {
                          setState(() {
                            Factura = [];
                            NoFact = TextEditingController(text: "");
                          });
                        },
                      )
                    ])))));

    final List = ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Factura.length,
        itemBuilder: (context, index) {
          return Container(
            height: 330,
            child: Card(
                elevation: 18.0,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Guía',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].no_guia}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Estatus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].status}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Accion',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].accion}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mensaje',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Logs.isEmpty
                            ? Text(
                                '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                '${Logs[2]}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    )))),
          );
        });

    final body = Column(children: [
      BotonConsulta,
      Column(children: [List])
    ]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(children: <Widget>[SingleChildScrollView(child: body)])
      ]),
    );
  }
}
