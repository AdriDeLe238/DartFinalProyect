import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartfinalproyect/add/validate_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';
import 'list/user.dart';
import 'login/login_summary.dart';
import 'main.dart';
import 'menu/animation_route.dart';

SharedPreferences? prefs;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login());
}

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home:LoginUser(title:'Login')
    );
  }
}

class LoginUser extends StatelessWidget{
  final String title;

  LoginUser({Key? key, required this.title}) : super (key:key);
  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blue,
    ));
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget{
  @override
  loginFormState createState(){
    return loginFormState();
  }
}

class loginFormState extends State<LoginForm>{
  final _formKey=GlobalKey<FormState>();
  var email =TextEditingController();
  var password =TextEditingController();
  ValidateText validate =ValidateText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            _getContent()
          ],
        ),
      ),
    );
  }
    Container _getContent(){
      return Container(
        child:Form(
          key: _formKey,
          child: ListView(
            children: [
              LoginSummary(horizontal:false),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    labelText: "Ingresa Email",
                    fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
                child: TextFormField(
                  obscureText: true,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    labelText: "Ingresa Contraseña",
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.enhanced_encryption),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Por favor ingrese el password';
                    }else{
                      if(6 > value.length){
                        return 'Por favor ingrese un password de 6 caracteres';
                      }
                    }
                  },
                  controller: password,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10.0),
                child: MaterialButton(
                 minWidth: 200.0,
                  height: 60.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  onPressed: (){
                   if(_formKey.currentState!.validate()){
                     signInWithCredentials(context);
                   }
                  },
                  child:setUpButtonChild(),
                  color:Colors.deepOrangeAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10.0),
                child: _signInButton()
              ),
            ],
          ),
        ),
      );
    }
    int _state=0;
    Widget setUpButtonChild(){
      if(_state==0){
        return Text(
          "Log In",
          style: const TextStyle(
            color:Colors.white,
            fontSize: 20,
          ),
        );
      }else if(_state==1){
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        );
      }else{
        return Text(
          "Log In",
          style: const TextStyle(
            color:Colors.white,
            fontSize: 20,
          ),
        );
      }
    }

    void animateButton(){
      setState(() {
        _state=1;
      });
      Timer(Duration(seconds:100),(){
        setState(() {
          _state=2;
        });
      });
    }

    void signInWithCredentials(BuildContext context){
      final _auth = FirebaseAuth.instance;
      final _db = FirebaseFirestore.instance;
      animateButton();
      _auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text
      ).then((value){
        Future<DocumentSnapshot> snapshot =  _db.collection('Alumnos').doc(email.text).get();
        snapshot.then((DocumentSnapshot user){
          Global.user = Users(
            user['ID'].toString(),
            user['Nombre'].toString(),
            user['Paterno'].toString(),
            user['Materno'].toString(),
            user['Image'].toString(),
            user.id,
            user['Role'].toString(),
            user['Active'].toString(),
          );
          Navigator.push(context, Animation_route(UserApp())).whenComplete(() => Navigator.of(context).pop());
        });
      }).catchError((e){
        setState(() {
          _state = 2;
        });
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      });
    }

    Future <User?> googleSignIn() async{
      FirebaseAuth _auth=FirebaseAuth.instance;
      GoogleSignIn _googleSignIn=GoogleSignIn();
      final GoogleSignInAccount? googleUser=await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth=await googleUser!.authentication;
      final AuthCredential credential=GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult=await _auth.signInWithCredential(credential);
      final User? user=authResult.user;
      assert(user!.email != null);
      assert(user!.displayName != null);
      final User? currentUser=await _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      return user;
    }

    void googleSignInUser(){
      final _db = FirebaseFirestore.instance;
      final _firebaseStorageRef=FirebaseStorage.instance;
      googleSignIn().then((User? data){
        Future<DocumentSnapshot> snapshot = _db.collection('Alumnos').doc(data!.email).get();
        snapshot.then((DocumentSnapshot user){
            Global.user=Users(
              user['ID'].toString(),
              user['Nombre'].toString(),
              user['Paterno'].toString(),
              user['Materno'].toString(),
              user['Image'].toString(),
              user.id,
              user['Role'].toString(),
              user['Active'].toString(),
            );
          Navigator.push(context, Animation_route(UserApp())).whenComplete(() => Navigator.of(context).pop());
        });
      }).catchError((e){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      });
    }

    Widget _signInButton(){
      return MaterialButton(
        minWidth: 200.0,
        height: 60.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: (){
          googleSignInUser();
        },
        child: Text(
          'Sign in with Google',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        color:Colors.teal,
      );
    }


  }