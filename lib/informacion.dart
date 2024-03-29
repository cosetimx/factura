import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Globals.dart' as globals;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class Documentos {
  String Tipo, Ruta, Descripcion, Documento;

  Documentos(
      {required this.Tipo,
      required this.Ruta,
      required this.Descripcion,
      required this.Documento});
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InfoPageMap();
    /*  Scaffold(
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Documentación'),
      ),
      body: Center(
        child: InfoPageMap(),
      ),
    ); */
  }
}

class InfoPageMap extends StatefulWidget {
  State<InfoPageMap> createState() => InfoPageState();
}

class InfoPageState extends State<InfoPageMap> {
  TextEditingController controller = new TextEditingController();
  ScrollController _rrectController = ScrollController();

  bool _isLoading = true;
  List<Documentos> Docs = [];

  Future getList() async {
    Docs = [];

    // TODO Conectar con el api php para obtener la lista de documentos
    _isLoading = false;

    try {
      String URL =
          "https://www.halcontracking.com/php/factura/documentos/get_documents.php";

      var response = await http.get(Uri.parse(URL));
      var extractdata = json.decode(response.body);
      var data = extractdata["Documentos"];
      if (extractdata["success"] == 1) {
        print("Data ${data.length - 30}");
        int Sized = data.length;
        if (data.length != 0) {
          for (int i = 0; i <= data.length - 1; i++) {
            Documentos docs =
                Documentos(Tipo: '', Descripcion: '', Documento: '', Ruta: '');
            docs.Tipo = data[i]['Tipo'];
            String descripcion = data[i]['Descripcion'];
            docs.Descripcion = descripcion;
            docs.Ruta = data[i]['Ruta'];
            docs.Documento = data[i]['Documento'];
            print('Descripcion $descripcion');
            var descrip = descripcion.split('-');

            setState(() {
              Docs.add(docs);
            });
          }
        } else {
          setState(() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Atención"),
                  content: new Text("Sin Documentación "),
                  actions: <Widget>[
                    new TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _isLoading = true;
                          });
                        },
                        child: new Text("Cerrar")),
                  ],
                );
              },
            );
          });
        }
      } else {
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Atención"),
                content: new Text("Favor de intentar más tarde"),
                actions: <Widget>[
                  new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = true;
                        });
                      },
                      child: new Text("Cerrar")),
                ],
              );
            },
          );
        });
      }
    } catch (e) {
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Atención"),
              content: new Text("Error $e"),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isLoading = true;
                      });
                    },
                    child: new Text("Cerrar")),
              ],
            );
          },
        );
      });
      print('Catch $e');
    }

    setState(() {
      _isLoading = true;
    });
  }

  shareImg(String Url, String Descripcion) async {
    final File _file = new File(Url);
    final _filename = path.basename(_file.path);
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(Url)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    await Printing.sharePdf(bytes: bytes, filename: _filename);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final listaf = Card(
        elevation: 18.0,
        color: Colors.grey[200], //indigo[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          //width: 100.0,
          height: (MediaQuery.of(context).size.height) - 20,
          child:
              //  Flexible(
              //   child:
              ListView.builder(
            itemCount: Docs.length,
            itemBuilder: (context, index) {
              final item = Docs[index];
              return Card(
                color: Colors.grey[200], //indigo[800],
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return FullPdfViewerScreen(item.Ruta, item.Descripcion);
                    }));
                  },
                  leading: SizedBox(
                    height: 94,
                    width: 64,
                    child: Icon(Icons.picture_as_pdf),
                  ),
                  title: Text(
                    '${index + 1} .- ${item.Descripcion}',
                    style: new TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey,
                  ),
                ),
              );
            },
          ),
          //    )
        ));

    final body1 = new Column(children: <Widget>[
      Container(
        color: Theme.of(context).primaryColor,
        child: Card(
          child: new ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              controller: controller,
              decoration: new InputDecoration(
                  hintText: 'Buscar', border: InputBorder.none),
              onChanged: onSearchTextChanged,
            ),
            trailing: new IconButton(
              icon: new Icon(
                Icons.cancel,
                color: Colors.teal,
              ),
              onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },
            ),
          ),
        ),
      ),
      Expanded(
          child: _searchResult.length != 0 || controller.text.isNotEmpty
              ? Scrollbar(
                  controller: _rrectController,
                  // isAlwaysShown: true,
                  child: ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      //final item = usuarios[index];
                      return Column(children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return FullPdfViewerScreen(
                                  _searchResult[index].Ruta,
                                  _searchResult[index].Descripcion);
                            }));
                          },
                          leading: SizedBox(
                            height: 94,
                            width: 64,
                            child: Icon(Icons.picture_as_pdf),
                          ),
                          title: Text(
                            '${index + 1} .- ${_searchResult[index].Descripcion}',
                            style: new TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ]);
                    },
                  ),
                  //    )
                )
              : Scrollbar(
                  controller: _rrectController,
                  // isAlwaysShown: true,
                  child: ListView.builder(
                    itemCount: Docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      //final item = usuarios[index];
                      return Column(children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return FullPdfViewerScreen(
                                  Docs[index].Ruta, Docs[index].Descripcion);
                            }));
                          },
                          leading: SizedBox(
                            height: 94,
                            width: 64,
                            child: Icon(Icons.picture_as_pdf),
                          ),
                          title: Text(
                            '${index + 1} .- ${Docs[index].Descripcion}',
                            style: new TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ]);
                    },
                  ),
                  //    )
                ))
    ]);

    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Archivos'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              onPressed: () {
                getList();
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: body1) //listaf
            : Center(
                child: CircularProgressIndicator(
                color: Colors.blueGrey,
              )));
  }

  List<Documentos> _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    Docs.forEach((DocsDetail) {
      if (DocsDetail.Descripcion.toUpperCase().contains(text.toUpperCase()))
        setState(() {
          _searchResult.add(DocsDetail);
        });
    });
  }
}

// PDF
class FullPdfViewerScreen extends StatelessWidget {
  final controller = PdfViewerController();

  @override
  void dispose() {
    controller.dispose();
    // super.dispose();
  }

  final String pdfPath;
  final String descripcion;

  FullPdfViewerScreen(this.pdfPath, this.descripcion);

  //Actualizar actualiza = Actualizar.instance;

  sharePdf(String Url, String Descripcion) async {
    final File _file = new File(Url);
    final _filename = path.basename(_file.path);
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(Url)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    await Printing.sharePdf(bytes: bytes, filename: _filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(descripcion, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              sharePdf(pdfPath, descripcion);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return QrCodeX(pdfPath);
              }));
            },
          ),
        ],
      ),
      body: PdfViewer.openFutureFile(
        // Accepting function that returns Future<String> of PDF file path
        () async => (await DefaultCacheManager().getSingleFile(pdfPath)).path,
        viewerController: controller,
        onError: (err) => print(err),
        params: PdfViewerParams(
          padding: 10,
          minScale: 1.0,
        ),
      ),
    );
  }
}

class QrCodeX extends StatelessWidget {
  final String Ruta;

  QrCodeX(this.Ruta);

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey,

      appBar: AppBar(
        title: Text('QR Code'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImageView(
                      data: Ruta,
                      size: 0.5 * MediaQuery.of(context).size.height -
                          MediaQuery.of(context).viewInsets.bottom,
                      backgroundColor: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary? boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      await Printing.sharePdf(bytes: pngBytes, filename: "image.png");

      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
