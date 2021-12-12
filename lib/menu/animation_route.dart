
import 'package:flutter/cupertino.dart';

class Animation_route extends PageRouteBuilder{
  final Widget widget;
  Animation_route(this.widget): super(
    transitionDuration: const Duration(
      days: 0,
      hours: 0,
      minutes: 0,
      milliseconds: 500,
      microseconds: 0
    ),
    pageBuilder: (BuildContext context, Animation<double> animation1,
    Animation<double> animation2){
      return widget;
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2,
        Widget child){
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)
          ).animate(CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
          child: child,
        );
        }
    );
}