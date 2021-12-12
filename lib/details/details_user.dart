import 'package:dartfinalproyect/details/separator.dart';
import 'package:dartfinalproyect/details/user_summary.dart';
import 'package:dartfinalproyect/list/user.dart';
import 'package:dartfinalproyect/menu/animation_route.dart';
import 'package:dartfinalproyect/menu/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';
import '../main.dart';

class DetailsUser extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detalles',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
      ),
      home: DetailUser(title: 'Detalles'),
    );
  }

}

class DetailUser extends StatelessWidget{
  final String? title;
  DetailUser({Key? key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title!), //Null check
        actions: [
          InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: (){
              Navigator.push(context, Animation_route (UserApp())).whenComplete(() => Navigator.of(context).pop());
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Details(),
      drawer: MenuLateral(),
    );
  }
  
}

class Details extends StatefulWidget{
  @override
 DetailsFormState createState() {
    // TODO: implement build
    return DetailsFormState();
  }
  
}

class DetailsFormState extends State<Details>{
  Users? _doc;
  DetailsFormState(){
    _doc = Global.doc;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: Container(
      constraints: BoxConstraints.expand(),
       color: Colors.black26,
       child: Stack(
         children: [
          _getBackground(),
           _getGradient(),
           _getContent()
         ],
       ),
     ),
   );
  }

  Container _getBackground(){
    return Container(
      child: Image.network(_doc!.Image, //Null check
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints:  BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient(){
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.black26,
            Colors.black38
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent(){
    final _overviewTitle = "información".toUpperCase();
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: [
          UserSummary(
            horizontal: false,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_overviewTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Separator(),
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod "
                    " tempor incididunt ut labore et dolore magna aliqua."
                    " Ut enim ad minim veniam, quis nostrud exercitation ullamco aboris nisi ut aliquip"
                    "x ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
                    "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat"
                    "non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}