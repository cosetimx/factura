import 'dart:core';
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
  String no_pedido;
  String factura;
  String carta_porte;
  String status_guia;
  //String timbrada;
  String cliente;
  /* String rfc_cliente;
  String calle_cliente;
  String numero_cliente;
  String colonia_cliente;
  String municipio_cliente;
  String localidad_cliente;
  String cp_cliente; */
  String remitente;
  String rfc_remi;
  String calle_remi;
  String numero_remi;
  String colonia_remi;
  String municipio_remi;
  String localidad_remi;
  String cp_remi;
  String destinatario;
  String rfc_desti;
  String calle_desti;
  String numero_desti;
  String colonia_desti;
  String municipio_desti;
  String localidad_desti;
  String cp_desti;
  String flete;
  String autopistas;
  String otros;
  String subtotal;
  String iva;
  String retencion;
  String total;
  String moneda;
  String fecha;
  String tipo;
  String clasificacion;
  String remolque;
  String operador;

  Consulta({
    required this.no_pedido,
    required this.carta_porte,
    required this.factura,
    required this.status_guia,
    //required this.timbrada,
    required this.cliente,
    /* required this.rfc_cliente,
    required this.calle_cliente,
    required this.numero_cliente,
    required this.colonia_cliente,
    required this.municipio_cliente,
    required this.localidad_cliente,
    required this.cp_cliente, */
    required this.remitente,
    required this.rfc_remi,
    required this.calle_remi,
    required this.numero_remi,
    required this.colonia_remi,
    required this.municipio_remi,
    required this.localidad_remi,
    required this.cp_remi,
    required this.destinatario,
    required this.rfc_desti,
    required this.calle_desti,
    required this.numero_desti,
    required this.colonia_desti,
    required this.municipio_desti,
    required this.localidad_desti,
    required this.cp_desti,
    required this.flete,
    required this.autopistas,
    required this.otros,
    required this.subtotal,
    required this.iva,
    required this.retencion,
    required this.total,
    required this.moneda,
    required this.fecha,
    required this.tipo,
    required this.clasificacion,
    required this.remolque,
    required this.operador,
  });

  factory Consulta.fromJson(Map<String, dynamic> parsedJson) {
    return Consulta(
        no_pedido: parsedJson['num_pedido'].toString() ?? '',
        carta_porte: parsedJson['carta_porte'].toString() ?? '',
        factura: parsedJson['factura'] ?? '',
        status_guia: parsedJson['status_guia'] ?? '',
       // timbrada: parsedJson['timbrada'] ?? '',
        cliente: parsedJson['cliente'] ?? '',
        /*  rfc_cliente: parsedJson['rfc_cliente'],
        calle_cliente: parsedJson['calle_cliente'],
        numero_cliente: parsedJson['numero_cliente'],
        colonia_cliente: parsedJson['colonia_cliente'],
        municipio_cliente: parsedJson['municipio_cliente'],
        localidad_cliente: parsedJson['localidad_cliente'],* /
        cp_cliente: parsedJson['cp_cliente'].toString(), */
        remitente: parsedJson['remitente'] ?? '',
        rfc_remi: parsedJson['rfc_remi'] ?? '',
        calle_remi: parsedJson['calle_remi'] ?? '',
        numero_remi: parsedJson['numero_remi'] ?? '',
        colonia_remi: parsedJson['colonia_remi'] ?? '',
        municipio_remi: parsedJson['municipio_remi'] ?? '',
        localidad_remi: parsedJson['localidad_remi'] ?? '',
        cp_remi: parsedJson['cp_remi'].toString() ?? '',
        destinatario: parsedJson['destinatario'] ?? '',
        rfc_desti: parsedJson['rfc_desti'] ?? '',
        calle_desti: parsedJson['calle_desti'] ?? '',
        numero_desti: parsedJson['numero_desti'] ?? '',
        colonia_desti: parsedJson['colonia_desti'] ?? '',
        municipio_desti: parsedJson['municipio_desti'] ?? '',
        localidad_desti: parsedJson['localidad_desti'] ?? '',
        cp_desti: parsedJson['cp_desti'].toString() ?? '',
        flete: double.parse(parsedJson['Flete']).toStringAsFixed(2) ?? '',
        autopistas: double.parse(parsedJson['Autopistas']).toStringAsFixed(2) ?? '',
        otros: double.parse(parsedJson['Otros']).toStringAsFixed(2) ?? '',
        subtotal: double.parse(parsedJson['Subtotal']).toStringAsFixed(2) ?? '',
        iva: double.parse(parsedJson['IVA']).toStringAsFixed(2) ?? '',
        retencion: double.parse(parsedJson['Retencion']).toStringAsFixed(2) ?? '',
        total: double.parse(parsedJson['Total']).toStringAsFixed(2) ?? '',
        moneda: parsedJson['Moneda'] ?? '',
        fecha: parsedJson['Fecha'] ?? '',
        tipo: parsedJson['tipo'] ?? '',
        clasificacion: parsedJson['clasificacion'] ?? '',
        operador: parsedJson['operador'] ?? '',
        remolque: parsedJson['remolque'] ?? '');
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
      monto: double.parse(parsedJson['monto']).toStringAsFixed(2),
      monto_iva_otro:
          double.parse(parsedJson['monto_iva_otro']).toStringAsFixed(2),
      monto_retencion:
          double.parse(parsedJson['monto_retencion']).toStringAsFixed(2),
      total: double.parse(parsedJson['total']).toStringAsFixed(2),
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
  TextEditingController controllerDescripcion = TextEditingController(text: "");
  List<Consulta> Factura = [];
  List<OtrosConceptos> OtrosConcepts = [];

  bool validdescripcion = false;
  bool _isLoading = false;
  bool pendiente = false;
  bool cargado = false;
  bool timbrada = false;
  bool cancelada = false;
  bool regresar = false;
  String factura = '';
  HttpClient client = new HttpClient();
  String descripcion = '';
  String _Estatus = '';

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

      if (jsonResponse['success'] == 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Atención"),
                content: Text("Enviada a Timbrar con Éxito"),
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
                content: Text("No se pudo Enviar"),
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
    setState(() {
      pendiente = false;
      timbrada = false;
      cancelada = false;
      regresar = false;
    });
  }

  Future cancelar() async {
    String factura = NoFact.text;
    String user = globals.USERS;
    String coms = descripcion;

    String URLs =
        "https://www.halcontracking.com/php/factura/cancelar.php?fact=$factura&user=$user&coms=$coms";

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
                content: Text("Enviada a cancelar con con Éxito"),
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
                content: Text("No se pudo Enviar"),
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
    setState(() {
      pendiente = false;
      timbrada = false;
      cancelada = false;
      regresar = false;
    });
  }

  Future<void> _regresar() async {
    String factura = NoFact.text;
    String user = globals.USERS;
    String coms = descripcion;

    String URLs =
        "https://www.halcontracking.com/php/factura/regresar.php?fact=$factura&user=$user&coms=$coms";

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
                content: Text("No se pudo Enviar"),
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
    setState(() {
      pendiente = false;
      timbrada = false;
      cancelada = false;
      regresar = false;
    });
  }

  Future _data(String factura) async {
    _isLoading = true;
    cargado = false;
    Factura = [];
    OtrosConcepts = [];
    pendiente = false;
    timbrada = false;
    cancelada = false;
    regresar = false;
    String URLs =
        "https://www.halcontracking.com/php/factura/consfactura.php?fact=$factura";

    print(URLs);
    var response = await http.get(Uri.parse(URLs));

    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
    // try {
        List Szs = jsonResponse['Result'][1]['Otros'];

        int Sizes = Szs.length;

        if (jsonResponse['success'] == 1) {
          var Datos = await jsonResponse['Result'][0]['Factura'][0];

          Consulta factura = new Consulta.fromJson(Datos);
          cargado = true;

          switch (factura.status_guia) {
            case 'A':
              pendiente = true;
              _Estatus = 'Pendiente';
              break;
            case 'B':
              cancelada = true;
              _Estatus = 'Cancelada';
              break;
            case 'C':
              timbrada = true;
              _Estatus = 'Confirmada';
              break;
            case 'R':
              regresar = true;
              _Estatus = 'Regreso';
              break;
            case 'T':
              pendiente = true;
              _Estatus = 'Transito';
              break;
          }

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
     /* } catch (e) {
        print('Error $e');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                  title: Text('Atención'),
                  content: Text(
                      'Error Folio no Encontrado o mal capturado, Favor de Verificar '),
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
      } */
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
                title: Text('Atención'),
                content: Text('Error de Conexion'),
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
    final BotonCancelar = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          fixedSize: Size.fromWidth(100),
          padding: EdgeInsets.all(10)),
      child: Text('Cancelar'), //Icon(Icons.cancel),
      onPressed: () async {
        if (validdescripcion) {
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
                        child: Text('Si'),
                        onPressed: () {
                          setState(() {
                            cancelar();
                          });
                          Navigator.of(contexts).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('No'),
                        onPressed: () async {
                          Navigator.of(contexts).pop();
                          setState(() {});
                        },
                      ),
                    ]);
              });
        } else {
          Fluttertoast.showToast(
              msg: "Campos sin llenar",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
    );

    final BotonEjecutar = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          fixedSize: Size.fromWidth(100),
          padding: EdgeInsets.all(10)),
      child: Text('Facturar'), //Icon(Icons.check),
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (BuildContext contexts) {
              return CupertinoAlertDialog(
                  title: Text(
                    "Atención",
                  ),
                  content: Text(
                    "¿Deseas Timbrar esta Carta Porte?",
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('SI'),
                      onPressed: () {
                        setState(() {
                          enviar();
                        });
                        Navigator.of(contexts).pop();
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

    final BotonRegresar = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          fixedSize: Size.fromWidth(100),
          padding: EdgeInsets.all(10)),
      child: Text('Regresar'), //Icon(Icons.check),
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (BuildContext contexts) {
              return CupertinoAlertDialog(
                  title: Text(
                    "Atención",
                  ),
                  content: Text(
                    "¿Deseas Regresar esta Carta Porte?",
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('SI'),
                      onPressed: () {
                        setState(() {
                          _regresar();
                        });
                        Navigator.of(contexts).pop();
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
                    title: Text("Carta Porte a Buscar"),
                    subtitle: TextField(
                      controller: NoFact,
                      keyboardType: TextInputType
                          .text, //numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'No. de Carta Porte',
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
                            setState(() {
                              Factura = [];
                              OtrosConcepts = [];
                              _data(NoFact.text);
                            });
                          }),
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
                            timbrada = false;
                            NoFact = TextEditingController(text: "");
                          });
                        },
                      )
                    ])))));

    final ListOtros = Card(
        elevation: 18.0,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
            padding: EdgeInsets.all(6.0),
            child:

            
             Column(children: [
              Text(
                'Otros Concetos',
                style: TextStyle(
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              Row(children: [
                Expanded(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: OtrosConcepts.length,
                        itemBuilder: (context, index) {
                          return Container(
                              child: Column(children: [
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        'Descripción: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${OtrosConcepts[index].desc_otro}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'IVA: ',
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
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(
                                      'Monto: ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.teal[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0),
                                    ),
                                    Text(
                                      '${OtrosConcepts[index].monto}',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                        //  fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Text(
                                      'Retención: ',
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
                                        fontSize: 10.0,
                                        //  fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])
                                ],
                              )),
                              Expanded(
                                child: Column(children: [
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
                                      fontSize: 10.0,
                                      //  fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                              ),
                            ]),
                            Divider(
                              height: 5,
                              color: Colors.teal,
                            )
                          ]));
                        }))
              ]),
            ])
            ));

    final cancela = Card(
        elevation: 18.0,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controllerDescripcion,
            decoration:
                const InputDecoration(labelText: 'Motivo de Cancelacion'),
            maxLines: 2,
            //    initialValue: primerApellido,
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Escribe Motivo de Cancelacion';
              } else {
                validdescripcion = true;
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                descripcion = value;
              });
            },
          ),
        ));

    final List = ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Factura.length,
        itemBuilder: (context, index) {
          return Container(
              height: 330,
              child: Column(
                children: [
                  Card(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                Text(
                                  'Estatus: $_Estatus',
                                  style: TextStyle(
                                      color: Colors.teal[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                IntrinsicHeight(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Fecha:',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.teal[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                          '${Factura[index].fecha}',
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: Colors.teal,
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Pedido:',
                                          style: TextStyle(
                                              color: Colors.teal[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                          '${Factura[index].no_pedido}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0,
                                            //  fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: Colors.teal,
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Carta Porte:',
                                          style: TextStyle(
                                              color: Colors.teal[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                          '${Factura[index].carta_porte}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0,
                                            //  fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: Colors.teal,
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Factura:',
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
                                            fontSize: 10.0,
                                            //  fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ])))),
                  Card(
                      elevation: 18.0,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: IntrinsicHeight(
                              child: Row(children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Cliente: ',
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
                                            fontSize: 10.0,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(children: [
                                      Text(
                                        'Remitente: ',
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
                                          fontSize: 10.0,
                                          //  fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'RFC: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].rfc_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Municipio: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].municipio_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Localidad: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].localidad_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Numero: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].numero_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Colonia: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].colonia_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          //  fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Calle: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].calle_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Codigo Postal: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].cp_remi}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                  ],
                                )),
                                const VerticalDivider(
                                  color: Colors.teal,
                                  width: 5,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(children: [
                                      Text(
                                        'Destinatario: ',
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
                                          fontSize: 10.0,
                                          //  fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'RFC: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].rfc_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Municipio: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].municipio_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Localidad: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].localidad_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Numero: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].numero_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Colonia: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].colonia_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          //  fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Calle: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].calle_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Codigo Postal: ',
                                        style: TextStyle(
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '${Factura[index].cp_desti}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                  ],
                                ))
                              ]),
                            ),
                          ))),
                  Card(
                      elevation: 18.0,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                              child: IntrinsicHeight(
                                  child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Tipo de Movimiento: ',
                                          style: TextStyle(
                                              color: Colors.teal[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                          '${Factura[index].tipo}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0,
                                            //  fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Operador: ',
                                          style: TextStyle(
                                              color: Colors.teal[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                          '${Factura[index].operador}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0,
                                            //  fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                color: Colors.teal,
                                width: 5,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                  child: Column(children: [
                                Row(
                                  children: [
                                    Text(
                                      'Clasificación: ',
                                      style: TextStyle(
                                          color: Colors.teal[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0),
                                    ),
                                    Text(
                                      '${Factura[index].clasificacion}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Remolque: ',
                                      style: TextStyle(
                                          color: Colors.teal[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0),
                                    ),
                                    Text(
                                      '${Factura[index].remolque}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ]))
                            ],
                          ))))),
                  Card(
                      elevation: 18.0,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                              child: IntrinsicHeight(
                                  child: Row(children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Flete:',
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
                                      fontSize: 10.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  'Autopistas:',
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
                                    fontSize: 10.0,
                                    //   fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  'Otros:',
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
                                    fontSize: 10.0,
                                    //  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  'SubTotal:',
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
                                    fontSize: 10.0,
                                    //  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  'IVA:',
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
                                    fontSize: 10.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            ),
                            Expanded(
                                child: Column(children: [
                              Text(
                                'Retención:',
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
                                  fontSize: 10.0,
                                  //   fontWeight: FontWeight.bold,
                                ),
                              ),
                            ])),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                      color: Colors.teal[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0),
                                ),
                                Text(
                                  '${Factura[index].total}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            )
                          ])))))
                ],
              ));
        });

    final body = Column(children: [
      BotonConsulta,
      Column(children: [List,
      OtrosConcepts.isNotEmpty ? 
       ListOtros: SizedBox(), !timbrada ? SizedBox() : cancela])
    ]);

    return cargado
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            persistentFooterButtons: [
              pendiente
                  ? BotonEjecutar
                  : timbrada
                      ? BotonCancelar
                      : regresar
                          ? BotonRegresar
                          : SizedBox()
            ],
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Menu'),
                  ),
                  ListTile(
                    title: const Text('Buscador'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
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
