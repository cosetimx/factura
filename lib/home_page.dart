import 'dart:core';
import 'dart:io';

import 'Globals.dart' as globals;
import 'components/menu.component.dart';

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
  String factura;
  String cliente;
  String rfc;
  String calle;
  String numero;
  String colonia;
  String municipio;
  String localidad;
  String codigo_postal;
  String remitente;
  String destinatario;
  String flete;
  String autopistas;
  String otros;
  String subtotal;
  String iva;
  String retencion;
  String total;
  String moneda;
  String fecha;

  Consulta({
    required this.no_guia,
    required this.factura,
    required this.cliente,
    required this.rfc,
    required this.calle,
    required this.numero,
    required this.colonia,
    required this.municipio,
    required this.localidad,
    required this.codigo_postal,
    required this.remitente,
    required this.destinatario,
    required this.flete,
    required this.autopistas,
    required this.otros,
    required this.subtotal,
    required this.iva,
    required this.retencion,
    required this.total,
    required this.moneda,
    required this.fecha,
  });

  factory Consulta.fromJson(Map<String, dynamic> parsedJson) {
    return Consulta(
        no_guia: parsedJson['no_guia'],
        factura: parsedJson['factura'],
        cliente: parsedJson['cliente'],
        rfc: parsedJson['rfc'],
        calle: parsedJson['calle'],
        numero: parsedJson['numero'],
        colonia: parsedJson['colonia'],
        municipio: parsedJson['municipio'],
        localidad: parsedJson['localidad'],
        codigo_postal: parsedJson['codigo_postal'],
        remitente: parsedJson['remitente'],
        destinatario: parsedJson['destinatario'],
        flete: parsedJson['Flete'],
        autopistas: parsedJson['Autopistas'],
        otros: parsedJson['Otros'],
        subtotal: parsedJson['Subtotal'],
        iva: parsedJson['IVA'],
        retencion: parsedJson['Retencion'],
        total: parsedJson['Total'],
        moneda: parsedJson['Moneda'],
        fecha: parsedJson['Fecha']);
  }
}

class OtrosConceptos {
  //int id;
  String desc_otro;
  String monto;
  String monto_iva_otro;
  String monto_retencion;
  String total;

  OtrosConceptos(
      {required this.desc_otro,
      required this.monto,
      required this.monto_iva_otro,
      required this.monto_retencion,
      required this.total});

  factory OtrosConceptos.fromJson(Map<String, dynamic> parsedJson) {
    return OtrosConceptos(
      //  id: parsedJson['id'],
      desc_otro: parsedJson['desc_otro'],
      monto: parsedJson['monto'],
      monto_iva_otro: parsedJson['monto_iva_otro'],
      monto_retencion: parsedJson['monto_retencion'],
      total: parsedJson['total'],
    );
  }
}

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Principal',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      drawer: XmobeMenu(),
      body: Center(child: HomePageMap()),
    );
  }
}

class HomePageMap extends StatefulWidget {
  State<HomePageMap> createState() => HomePageState();
}

class HomePageState extends State<HomePageMap> {
  TextEditingController NoFact = TextEditingController(text: "");
  List<Consulta> Factura = [];
  List<OtrosConceptos> OtrosConcepts = [];

  bool _isLoading = false;
  bool cargado = false;
  String factura = '';
  HttpClient client = new HttpClient();

  @override
  void initState() {
    super.initState();
  }

  Future enviar() async {
    String factura = NoFact.text;
    String URLs =
        "https://www.halcontracking.com/php/factura/realizar.php?fact=$factura";

    print(URLs);
    var response = await http.get(Uri.parse(URLs));
    try {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['Success'] == 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Atención"),
                content: Text("Informacion Enviada Correctamente"),
                actions: <Widget>[
                  CupertinoDialogAction(
                 child: Text("Cerrar"),
                    onPressed: () {
                      setState(() {
                        Factura = [];
                        OtrosConcepts = [];
                        cargado = false;
                        NoFact = TextEditingController(text: "");
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Atención"),
                content: Text("Sin Resultados"),
                actions: <Widget>[
                  CupertinoDialogAction(

                    child: Text("Cerrar"),
                    onPressed: () {
                      setState(() {
                        Factura = [];
                        OtrosConcepts = [];
                        cargado = false;
                        NoFact = TextEditingController(text: "");
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } catch (e) {
      var error = response.body.split("]");
      String message = error[3];

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Atención"),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Cerrar"),
                  onPressed: () {
                    setState(() {
                      Factura = [];
                      OtrosConcepts = [];
                      cargado = false;
                      NoFact = TextEditingController(text: "");
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
 Future cancelar() async {
    String factura = NoFact.text;
    String URLs =
        "https://www.halcontracking.com/php/factura/cancelar.php?fact=$factura";

    print(URLs);
    var response = await http.get(Uri.parse(URLs));
    try {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['Success'] == 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Atención"),
                content: Text("Informacion Enviada Correctamente"),
                actions: <Widget>[
                  CupertinoDialogAction(
                 child: Text("Cerrar"),
                    onPressed: () {
                      setState(() {
                        Factura = [];
                        OtrosConcepts = [];
                        cargado = false;
                        NoFact = TextEditingController(text: "");
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Atención"),
                content: Text("Sin Resultados"),
                actions: <Widget>[
                  CupertinoDialogAction(

                    child: Text("Cerrar"),
                    onPressed: () {
                      setState(() {
                        Factura = [];
                        OtrosConcepts = [];
                        cargado = false;
                        NoFact = TextEditingController(text: "");
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } catch (e) {
      var error = response.body.split("]");
      String message = error[3];

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Atención"),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Cerrar"),
                  onPressed: () {
                    setState(() {
                      Factura = [];
                      OtrosConcepts = [];
                      cargado = false;
                      NoFact = TextEditingController(text: "");
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future _data(String factura) async {
    _isLoading = true;
    cargado = false;
    Factura = [];
    OtrosConcepts = [];

    String URLs =
        "https://www.halcontracking.com/php/factura/consfactura.php?fact=$factura";

    print(URLs);
    var response = await http.get(Uri.parse(URLs));

    final jsonResponse = json.decode(response.body);
    try {
      List Szs = jsonResponse['Result'][1]['Otros'];

      int Sizes = Szs.length;

      if (jsonResponse['success'] == 1) {
        var Datos = await jsonResponse['Result'][0]['Factura'][0];

        Consulta factura = new Consulta.fromJson(Datos);
        cargado = true;

        setState(() {
          Factura.add(factura);
        });
        for (var i = 0; i < Sizes; i++) {
          var ODatos = jsonResponse['Result'][1]['Otros'][i];
          OtrosConceptos OtrosDatos = new OtrosConceptos.fromJson(ODatos);
          setState(() {
            OtrosConcepts.add(OtrosDatos);
          });
        }
      }
    } catch (e) {
      print('Error $e');
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return 
      CupertinoAlertDialog(
          title: Text('Atención'),
          content: Text('Factura no encontrada'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('NO'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ]);  });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {


    final BotonCancelar = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          fixedSize: Size.fromWidth(100),
          padding: EdgeInsets.all(10)),
      child: Icon(Icons.cancel),
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (BuildContext contexts) {
              return CupertinoAlertDialog(
                  title: Text(
                    "Atención",
                  ),
                  content: Text(
                    "¿Deseas Cancelar esta Factura?",
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('SI'),
                      onPressed: () {
                        Navigator.of(contexts).pop();
                        setState(() {
                          enviar();
                        });
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('NO'),
                      onPressed: () async {
                        Navigator.of(contexts).pop();
                        setState(() {});
                      },
                    ),
                  ]);
            });
      },
    );

    final BotonEjecutar = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          fixedSize: Size.fromWidth(100),
          padding: EdgeInsets.all(10)),
      child: Icon(Icons.check),
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (BuildContext contexts) {
              return CupertinoAlertDialog(
                  title: Text(
                    "Atención",
                  ),
                  content: Text(
                    "¿Deseas Ingresar esta Factura?",
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('SI'),
                      onPressed: () {
                        Navigator.of(contexts).pop();
                        setState(() {
                          enviar();
                        });
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('NO'),
                      onPressed: () async {
                        Navigator.of(contexts).pop();
                        setState(() {});
                      },
                    ),
                  ]);
            });
      },
    );

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
                    title: Text("Factura a Buscar"),
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
                            OtrosConcepts = [];
                            cargado = false;
                            NoFact = TextEditingController(text: "");
                          });
                        },
                      )
                    ])))));

    final ListOtros = ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: OtrosConcepts.length,
        itemBuilder: (context, index) {
          return Container(
              height: 105,
              child: Card(
                  elevation: 18.0,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Descripción',
                                style: TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              Text(
                                '${OtrosConcepts[index].desc_otro}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'IVA',
                                style: TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              Text(
                                '${OtrosConcepts[index].monto_iva_otro}',
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
                                'Total',
                                style: TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              Text(
                                '${OtrosConcepts[index].total} ',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  //  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Monto',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.teal[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0),
                            ),
                            Text(
                              '${OtrosConcepts[index].monto}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                //  fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Retención',
                              style: TextStyle(
                                  color: Colors.teal[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0),
                            ),
                            Text(
                              '${OtrosConcepts[index].monto_retencion}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                //  fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ))
                      ]))));
        });

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
                  child: Row(children: [
                    Expanded(
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
                          'Fecha',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].fecha}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Cliente',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].cliente}',
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
                          'Calle',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].calle}',
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
                          'Colonia',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].colonia}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Localidad',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].localidad}',
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
                          'Remitente',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].remitente}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Flete',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].flete}',
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
                          'Otros',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].otros}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'IVA',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].iva}',
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
                          'Moneda',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].moneda}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Factura',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].factura}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'RFC',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].rfc}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Número',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].numero}',
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
                          'Municipio',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].municipio}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Código Postal',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].codigo_postal}',
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
                          'Destinatario',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].destinatario}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Autopistas',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].autopistas}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //   fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'SubTotal',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].subtotal}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Retención',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        Text(
                          '${Factura[index].retencion}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            //   fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ))
                  ]),
                )),
          );
        });

    final body = Column(children: [
      BotonConsulta,
      List,
      ListOtros,
    ]);

    return cargado
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            persistentFooterButtons: [BotonEjecutar, BotonCancelar],
            body: Stack(children: <Widget>[
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: <Widget>[SingleChildScrollView(child: body)])
            ]),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,

            // persistentFooterButtons: [BotonEjecutar],
            body: Stack(children: <Widget>[
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: <Widget>[SingleChildScrollView(child: body)])
            ]),
          );
  }
}
