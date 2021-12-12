import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:dartfinalproyect/list/list_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';
import 'list/list_user.dart';
import 'list/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(UserApp());
}

class UserApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: HomePageMain(),
      routes: <String, WidgetBuilder>{

      },
    );
  }


}

class HomePageMain extends StatefulWidget{
  @override
  _SearchListSatate createState() => new _SearchListSatate();

}

class _SearchListSatate extends State<HomePageMain>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListUser(),
    );
  }

}