
import 'package:dartfinalproyect/add/add_user.dart';
import 'package:dartfinalproyect/main.dart';
import 'package:dartfinalproyect/menu/animation_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';
import '../login.dart';

class MenuLateral extends StatefulWidget{
  @override
  Menu createState() => Menu();
}

class Menu extends State<MenuLateral>{

  String _nombre=Global.user!.Nombre + Global.user!.Paterno +Global.user!.Materno;
  String _imagen=Global.user!.Image;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child:
      ListView(
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
              child: Text(
               _nombre,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              ),
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: NetworkImage(_imagen),
                fit:BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color(0x95120228),
            ),
            title: const Text('Inicio'),
              onTap: () {
              Global.doc = null;
              Navigator.push(context, Animation_route (UserApp())).whenComplete(() => Navigator.of(context).pop());
            }
          ),
          ListTile(
              leading: const Icon(
                Icons.person,
                color: Color(0x95120228),
              ),
              title: const Text('Registrar'),
              onTap: () {
                Global.doc = null;
                Navigator.push(context, Animation_route (AddUser())).whenComplete(() => Navigator.of(context).pop());
              }
          ),
          ListTile(
            leading: new Icon(
              Icons.close,
              color: Colors.red,
            ),
            title:Text('Salir'),
              onTap: () {
                Global.doc = null;
                Global.user = null;
                Navigator.push(context, Animation_route (Login())).whenComplete(() => Navigator.of(context).pop());
              }
          ),
        ],
      ),
    );
  }


}