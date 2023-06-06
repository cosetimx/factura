import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:factura/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:universal_platform/universal_platform.dart';

import 'Globals.dart' as globals;
import 'main.dart';

Future<Post> createPost(Uri url, {required Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    print(response.body);
    return Post.fromJson(json.decode(response.body));
  });
}

class LoginPage extends StatelessWidget {
  static String tag = 'login-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LoginPageMap()),
    );
  }
}

class LoginPageMap extends StatefulWidget {
  @override
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginPageMap() : super();

  @override
  LoginPageState createState() => LoginPageState(_scaffoldKey);
}

/* ----------------------------- */

class LoginPageState extends State<LoginPageMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  HttpClient client = new HttpClient();
  bool _loading = false;
  TextEditingController users = TextEditingController(text: "");

  TextEditingController passwd = TextEditingController(text: "");
  LoginPageState(this._scaffoldKey);
  // static final CREATE_POST_URL =  'https://www.halcontracking.com/php/factura/login.php';

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: Image.asset('assets/logo.png'),
      ),
    );

    final control = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'REVISIÓN DE FACTURAS',
        style: TextStyle(
            fontSize: 18.0, color: Colors.teal[800], fontStyle: FontStyle.normal),
        textAlign: TextAlign.center,
      ),
    );

    final user = Theme(
        data: new ThemeData(
          primaryColor: Colors.teal,
          hintColor: Colors.grey,
        ),
        child: TextField(
          cursorColor: Colors.teal,
          controller: users,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Usuario',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            filled: true,
            fillColor: Colors.white,
          ),
        ));

    final password = Theme(
        data: new ThemeData(
          primaryColor: Colors.teal,
          hintColor: Colors.grey,
        ),
        child: TextField(
          cursorColor: Colors.teal,
          controller: passwd,
          autofocus: false,
          obscureText: true,
          // onChanged: (textValue) { passwd = TextEditingController(text: textValue);},

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Contraseña',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
        ));

    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Column(children: [
          IconButton(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              try {
                String URLs =
                    'https://www.halcontracking.com/php/factura/login.php?username=${users.text}&password=${passwd.text}';

                var response = await http.get(Uri.parse(URLs));

                Map data = json.decode(response.body);
                print('Data $data');
                if (data['success'] == 1) {
                  globals.PASSWD = passwd.text;
                  globals.USERS = users.text;
                  globals.NOMBRE = data['result'][0]['nombre'];
                  globals.TIPO = data['result'][0]['tipo'];
                  globals.USERLIS = data['result'][0]['usuariolis'];
                     Navigator.pushNamed(context, HomePage.tag);
                  _loading = false;
                } else {
                  setState(() {
                    _loading = false;
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text('Atención'),
                        content: Text('Nombre de usuario o contraseña incorrectos'),
                        actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Cerrar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        
                      },
                    ),]
                      );
                    },
                  );
                }
              } catch (Exception) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text('Atención'),
                      content: Text('Error de Conexión $Exception'),
                      actions: <Widget>[
                      CupertinoDialogAction(
                      child: Text('Cerrar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        
                      },
                    ),]
                    );
                  },
                );
              }
            },
            iconSize: 48,
            tooltip: 'Ingresar',
            icon: Icon(
              Icons.login,
              color: Colors.teal,
            ),
          ),
          Text('Ingresar', style: TextStyle(color: Colors.teal, fontSize: 20))
        ]));

    final body = Column(
      // shrinkWrap: true,
      // padding: EdgeInsets.only(left: 4.0, right: 4.0),
      children: <Widget>[
        SizedBox(height: 40.0),
            
        logo,
        control,
        // Version
        Text(
          'V 1.10',
          style: TextStyle(fontSize: 8.0, color: Colors.teal),
        ),
        user,
        SizedBox(height: 12.0),
        password,
        SizedBox(height: 12.0),
        loginButton
      ],
    );
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.white,
        body: Stack(children: <Widget>[SingleChildScrollView(child: body)]));
  }
}

class Post {
  final String user;
  final String pass;

  Post({required this.user, required this.pass});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      user: json['username'],
      pass: json['password'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = user;
    map["password"] = pass;

    return map;
  }
}

class ShowDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;

  ShowDialogToDismiss(
      {required this.title, required this.buttonText, required this.content});

  @override
  Widget build(BuildContext context) {

      return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: new Text(
            this.content,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                buttonText[0].toUpperCase() +
                    buttonText.substring(1).toLowerCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);

}
}
