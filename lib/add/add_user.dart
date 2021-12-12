import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartfinalproyect/add/card_foto.dart';
import 'package:dartfinalproyect/details/details_user.dart';
import 'package:dartfinalproyect/list/user.dart';
import 'package:dartfinalproyect/main.dart';
import 'package:dartfinalproyect/menu/animation_route.dart';
import 'package:dartfinalproyect/menu/menu_lateral.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';

void main() => runApp(AddUser());

class AddUser extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Registrar',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
        ),
        home: HomePage(title: 'Registrar'),
        routes: <String, WidgetBuilder>{

        }
    );
  }
}

class HomePage extends StatelessWidget{
  final String title;
  HomePage({ Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          InkWell(
              child: const Icon(Icons.arrow_back_ios,
                color: Color(0xffffffff),
              ),
              onTap:(){
                if (Global.doc != null){
                  Navigator.push(context,Animation_route(DetailsUser())).whenComplete(() => Navigator.of(context).pop());
                }else{
                  Navigator.push(context,Animation_route(UserApp())).whenComplete(() => Navigator.of(context).pop());
                }
              }
          ),
          SizedBox(width: 10),
        ],
      ),
      body: UserForm(),
      drawer: MenuLateral(),
    );
  }

}

class UserForm extends StatefulWidget{
  @override
  UserFormState createState(){
    return UserFormState();
  }

}

class UserFormState extends State<UserForm>{
  final _formkey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var id = TextEditingController();
  var name = TextEditingController();
  var appaterno = TextEditingController();
  var apmaterno = TextEditingController();
  List _roles = ["User", "Admin"];
  late List<DropdownMenuItem<String>> _dropDownRolesItems;
  late String _currentRole, _image;
  bool _isEnabled = true;

  @override
  void initState(){
    //_dropDownMenuItems = getDropDownMenuItems();
    _dropDownRolesItems = getDropDownRoleItems();
    _currentRole = _dropDownRolesItems[0].value!;
    if(Global.doc != null){
      id.text = Global.doc!.ID;
      name.text = Global.doc!.Nombre;
      appaterno.text = Global.doc!.Paterno;
      apmaterno.text = Global.doc!.Materno;
      _currentRole = Global.doc!.Role;
      _image = Global.doc!.Image;
      email.text = (("al")+(Global.doc!.ID)+("@edu.uaa.mx"));
      password.text = "***";
      _isEnabled = false;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formkey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            child:CardFotos(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Escribe tu ID",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.add ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(

                    ),
                  )
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Por favor ingrese el ID';
                }
              },
              controller: id,
              enabled: _isEnabled,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Escribe tu Nombre",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(

                    ),
                  )
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Por favor ingrese el nombre';
                }
              },
              controller: name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Apellido Paterno",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(

                    ),
                  )
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Por favor ingrese el apellido paterno';
                }
              },
              controller: appaterno,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Apellido Materno",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(

                    ),
                  )
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Por favor ingrese el apellido materno';
                }
              },
              controller: apmaterno,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    labelText: "Escribe tu correo institucional",
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(

                      ),
                    )
                ),
                validator: (value){
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  if (value!.isEmpty){
                    return 'Por favor ingrese el email';
                  }else{
                    RegExp regex = RegExp(pattern.toString());
                    if (!regex.hasMatch(value)){
                      return 'Escriba un correo valido';
                    }
                  }
                },
                controller: email,
                enabled: _isEnabled
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
                obscureText: true,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  labelText: "Escribe tu contraseña",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.enhanced_encryption),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                    ),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Por favor ingrese el password';
                  }else{
                    if(3 > value.length){
                      return 'Por favor ingrese un password de 6 caracteres';
                    }
                  }
                },
                controller: password,
                enabled: _isEnabled
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: DropdownButton(
              value: _currentRole,
              items: _dropDownRolesItems,
              onChanged: changedDropDownRoles,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            child: MaterialButton(
              minWidth: 200.0,
              height: 60.0,
              onPressed: () {
                if(_formkey.currentState!.validate()){
                  if(Global.doc == null) {
                    registrar(context);
                  }else{
                    actualizar();
                  }
                }
              },
              color: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: setUpButtonChild(),
            ),
          ),
        ],
      ),
    );
  }
  int _state = 0;
  Widget setUpButtonChild(){
    if(_state == 0){
      return Text(
        "Registrar",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }else if(_state == 1){
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }else{
      return Text(
        "Registrar",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }
  }

  registrar(BuildContext context) async{
    final _auth = FirebaseAuth.instance;
    final _firebaseStorageRef = FirebaseStorage.instance;
    final _db = FirebaseFirestore.instance;
    var image = CardFoto.croppedFile;
    if(image != null){
      setState((){
        if(_state == 0){
          animateButton();
        }
      });
      await _auth.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text
      ).then((value){
        UploadTask task = _firebaseStorageRef.ref().child("Users").child("${email.text}").putFile(image);
        task.whenComplete(() async {
          TaskSnapshot storageTaskSnapshot = task.snapshot;
          String imgUrl = await storageTaskSnapshot.ref.getDownloadURL();
          DocumentReference ref = _db.collection('Alumnos').doc(email.text);
          ref.set({
            'ID': id.text,
            'Nombre': name.text,
            'Paterno': appaterno.text,
            'Materno': apmaterno.text,
            'Image': '$imgUrl',
            'Role': _currentRole,
            'Active': 'true',
          })
              .then((value){
            Navigator.push(context, Animation_route(HomePageMain())).whenComplete(() => Navigator.of(context).pop());
          });
        });
      }).catchError((e)=>{
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(e.mesage))),
      });
    }
  }

  void animateButton(){
    setState(() {
      _state = 1;
    });
    Timer(Duration(seconds: 60), (){
      _state = 2;
    });
  }
  List<DropdownMenuItem<String>> getDropDownRoleItems(){
    List<DropdownMenuItem<String>> items = [];
    for(String item in _roles){
      items.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ));
    }
    return items;
  }
  void changedDropDownRoles(String? selectedRole){
    setState((){
      _currentRole = selectedRole!;
    });
  }
  actualizar() async{
    final _firebaseStorageRef = FirebaseStorage.instance;
    final _db = FirebaseFirestore.instance;
    var image = CardFoto.croppedFile;
    var dataImage;
    var value = false;
    DocumentReference ref = _db.collection('Alumnos').doc(email.text);
    setState((){
      if  (_state == 0){
        animateButton();
      }
    });
    if (image != null){
      UploadTask task = _firebaseStorageRef.ref().child("Alumnos").child("${email.text}").putFile(image);
      task.whenComplete(() async{
        TaskSnapshot storageTaskSnapshot = task.snapshot;
        dataImage = await storageTaskSnapshot.ref.getDownloadURL();
        value = true;
      });
    }else{
      if(_image != null){
        dataImage = _image;
        value = true;
      }else{
        value = false;
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Seleccione una imagen'))
        );
      }
    }
    if (value){
      ref.set({
        'ID': id.text,
        'Nombre' : name.text,
        'Paterno' : appaterno.text,
        'Materno' : apmaterno.text,
        'Image' : dataImage,
        'Role' : _currentRole,
        'Active' : Global.doc!.Active,
      }).then((value){
        Future<DocumentSnapshot> snapshot = _db.collection('Alumnos').doc(email.text).get();
        snapshot.then((DocumentSnapshot user){
          Global.doc = Users(
            (user.data() as dynamic)['ID'], //doc.data()['Id']
            (user.data() as dynamic)['Nombre'], //doc.data()['Name']
            (user.data() as dynamic)['Paterno'], //doc.data()['LastNameP']
            (user.data() as dynamic)['Materno'], //doc.data()['LastNameM']
            (user.data() as dynamic)["Image"],
            user.id,
            (user.data() as dynamic)["Role"],
            (user.data() as dynamic)["Active"],
          );
          Navigator.push(context, Animation_route(DetailsUser())).whenComplete(() => Navigator.of(context).pop());
        });
      });
    }
  }
}