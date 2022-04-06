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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController NoFact = TextEditingController(text: "");
  List<Consulta> Factura = [];
  List<OtrosConceptos> OtrosConcepts = [];

  bool _isLoading = false;
  String factura = '';
  HttpClient client = new HttpClient();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
  }

  Future _data(String factura) async {
    _isLoading = true;
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
          return ShowDialogToDismiss(
            title: 'Atención',
            content: 'Lista Vacía',
            buttonText: 'Cerrar',
          );
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BotonConsulta = 
    Container(
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
                  child:
    
    ListTile(
        leading: Icon(Icons.assignment),
        title: Text("Factura a Buscar"),
        subtitle: TextField(
          controller: NoFact,
          keyboardType: TextInputType.text, //numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'No. de Factura',
            contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           IconButton(
              iconSize: 18,
              icon: Icon(Icons.check, color: Colors.teal[800], ),
              
              onPressed: () {
                _data(NoFact.text);
              },
            ),
          
          IconButton(
              icon: Icon(Icons.cancel, color: Colors.teal[800],),
              iconSize: 18,
              onPressed: () {
                setState(() {
                  Factura = [];
                  OtrosConcepts = [];
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
                              new Text(
                                'Descripción',
                                style: TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              new Text(
                                '${OtrosConcepts[index].desc_otro}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                 // fontWeight: FontWeight.bold,
                                ),
                              ),
                              new Text(
                                'IVA',
                                style: TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              new Text(
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
                              new Text(
                                'Total',
                                style: TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              new Text(
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
                            new Text(
                              'Monto',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.teal[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0),
                            ),
                            new Text(
                              '${OtrosConcepts[index].monto}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              //  fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text(
                              'Retención',
                              style: TextStyle(
                                  color: Colors.teal[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0),
                            ),
                            new Text(
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
            height: 320,
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
                        new Text(
                          'Guía',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
                          '${Factura[index].no_guia}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          //  fontWeight: FontWeight.bold,
                          ),
                        ),
                        new Text(
                          'Fecha',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
                          '${Factura[index].fecha}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                           // fontWeight: FontWeight.bold,
                          ),
                        ),
                        new Text(
                          'Cliente',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Calle',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Colonia',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Localidad',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Remitente',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Flete',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Otros',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'IVA',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Moneda',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Factura',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'RFC',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Número',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Municipio',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Código Postal',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Destinatario',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Autopistas',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'SubTotal',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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
                        new Text(
                          'Retención',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        new Text(
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

    final body = Column(children: [BotonConsulta, List, ListOtros]);

    return new Scaffold(
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
