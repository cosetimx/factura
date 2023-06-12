import 'package:factura/buscador.dart';
import 'package:factura/home_page.dart';

import 'package:flutter/material.dart';
import '../Globals.dart' as globals;
import '../main.dart';
import '../home_page.dart';

final List<MenuItem> menuItems = <MenuItem>[
  MenuItem('Carta Porte', HomePage(), Icons.home),

  MenuItem('Buscador', CunsultaView(), Icons.search),
  // MenuItem('Descarga', DescargaPage(), MaterialCommunityIcons.fuel),
  // MenuItem('Volumen', DiarioPage(), FontAwesome5Solid.calendar_day),
  // MenuItem('Precios', PrecioPage(), FlutterIcons.fuel_mco),

  MenuItem('Cerrar Sesión', MyApp(), Icons.logout),
];

class XmobeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: new ListView(children: <Widget>[
      new UserAccountsDrawerHeader(
        accountEmail: null,
        accountName: new Text("Bienvenido \n\r ${globals.NOMBRE}"),
        currentAccountPicture: ClipOval(
          child: Image.asset('assets/logo.png', fit: BoxFit.fill),
        ),
      ),
      new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return MenuItemWidget(menuItems[index]);
        },
        itemCount: menuItems.length,
      ),
    ]));
  }
}

class MenuItem {
  MenuItem(this.title, this.page, this.icon);

  final String title;
  final StatelessWidget page;
  final IconData icon;
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;

  const MenuItemWidget(this.item);

  Widget _buildMenu(MenuItem menuItem, context) {
    return ListTile(
      leading: Icon(
        menuItem.icon,
        color: Colors.teal,
      ),
      title: Text(
        menuItem.title,
        style: TextStyle(color: Colors.teal),
      ),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => menuItem.page,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMenu(this.item, context);
  }
}
