import 'package:dartfinalproyect/add/add_user.dart';
import 'package:dartfinalproyect/details/separator.dart';
import 'package:dartfinalproyect/list/user.dart';
import 'package:dartfinalproyect/menu/animation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class UserSummary extends StatelessWidget{
  final bool horizontal;
  Users? _doc; //late Users? _doc;
  UserSummary({required this.horizontal}){ //required
    _doc = Global.doc;
  }
  @override
  Widget build(BuildContext context) {
    final imageThumbnail = Container(
      margin: EdgeInsets.symmetric(
          vertical: 16.0
      ),
      alignment: horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Container(
        height: 30.0,
        width: 90.0,
        decoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
              image: NetworkImage(_doc!.Image), //Null Check
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                //SOMBRAS
                color: Color(0xffA4A4A4),
                offset: Offset(1.0, 5.0),
                blurRadius: 3.0,
              ),
            ]
        ),
      ),
    );
    Widget _userValue({String? value, IconData? icono}){
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: Colors.white, size: 15.0,),
            Container(width: 8.0),
            Text(value!, //nul check
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            )
          ],
        ),
      );
    }
    final userCardContent = Container(
      margin: EdgeInsets.fromLTRB(horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(height: 4.0),
          Text(
            "${_doc!.Nombre} ${_doc!.Paterno}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Container(height: 10.0),
          Text("${_doc!.ID}"),
          Separator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: horizontal ? 1: 0,
                child: _userValue(
                  value: _doc!.Role,
                  icono: Icons.admin_panel_settings,
                ),
              ),
              Container(width: 8.0),
              Expanded(
                flex: horizontal ? 1: 0,
                child: _userValue(
                  value: _doc!.ID,
                  icono: Icons.vpn_key,
                ),
              ),
              Container(
                width: 32.0,
              ),
            ],
          ),
        ],
      ),
    );
    final userCard = Container(
      child: userCardContent,
      height: horizontal ? 124.0 : 154.0,
      margin: horizontal ? EdgeInsets.only(left: 46.0) : EdgeInsets.only(top: 72.0),
      decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            )
          ]
      ),
    );
    return InkWell(
      onTap: ()=>Navigator.push(context,Animation_route (AddUser())).whenComplete(() => Navigator.of(context).pop()),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: [
            userCard,
            imageThumbnail
          ],
        ),
      ),
    );
//    throw UnimplementedError();
  }

}