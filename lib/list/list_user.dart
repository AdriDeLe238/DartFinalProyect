import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartfinalproyect/details/details_user.dart';
import 'package:dartfinalproyect/list/user.dart';
import 'package:dartfinalproyect/menu/animation_route.dart';
import 'package:dartfinalproyect/menu/menu_lateral.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';
//import 'package:flutter_image/flutter_image.dart';

class ListUser extends StatefulWidget{
  @override
  ListUserState createState() => ListUserState();
}

class ListUserState extends State<ListUser>{
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _db = FirebaseFirestore.instance;
  late List<Users> listUser; //late
  late Widget _users; //late
  bool? _isSearching;
  final _controller = new TextEditingController();
  @override
  void initState(){
    super.initState();
    Firebase.initializeApp();
    //listUser = List<Users>();
    listUser = <Users>[];
    _users = SizedBox();
    _isSearching = false;
    readData();
  }
  Widget appBarTitle = Text(
    "Alumnos",
    style: TextStyle(color: Colors.white),
  );
  Icon icon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
            icon: icon,
            onPressed: (){
              setState((){
                if(this.icon.icon == Icons.search){
                  this.icon = Icon(
                    Icons.close,
                    color:Colors.white,
                  );
                  this.appBarTitle = TextField(
                    controller: _controller,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color:Colors.white),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white)
                    ),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                }else{
                  searchOperation(null);
                  _handleSearchStart();
                }
              });
            },
          ),
        ],
      ),
      drawer: MenuLateral(),
      body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: readData,
          child: ListView(
            children: [
              _users
            ],
          )
      ),
    );
  }
  Future<void> readData()async{
    Stream<QuerySnapshot> qs = _db.collection('Alumnos').snapshots();
    qs.listen((QuerySnapshot onData)=> {
      listUser.clear(),
      onData.docs.map((doc)=>{
        listUser.add(Users(
            (doc.data() as dynamic)['ID'], //doc.data()['Id']
            (doc.data() as dynamic)['Nombre'], //doc.data()['Name']
            (doc.data() as dynamic)['Paterno'], //doc.data()['LastNameP']
            (doc.data() as dynamic)['Materno'], //doc.data()['LastNameM']
            (doc.data() as dynamic)["Image"],
            doc.id,
            (doc.data() as dynamic)["Role"],
            (doc.data() as dynamic)["Active"],

        )),
      }).toList(),
      userList(null),
    });
  }
  Container buildItem(Users doc){
    return Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      child:Stack(
        children: [
          card(doc),
          thumbnail(doc)
        ],
      ),
    );
  }
  GestureDetector card(Users doc){
    return GestureDetector(
      onTap: (){
        Global.doc = doc;
        Navigator.push(context, Animation_route(DetailsUser())).whenComplete(() => Navigator.of(context).pop());
      },
      child: Container(
        height:  130.0,
        margin: EdgeInsets.only(left: 46.0),
        decoration: BoxDecoration(
            color:Colors.black26,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color:Colors.black38,
                blurRadius: 5.0,
                offset: Offset(0.0, 5.0),
              )
            ]
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${doc.ID}',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${doc.Nombre}',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${doc.Paterno} ',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${doc.Materno}',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '${doc.Role}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container thumbnail(Users doc){
    return Container(
      alignment: FractionalOffset.centerLeft,
      child: Container(
        height: 90.0,
        width: 90.0,
        decoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50.0),
            image:DecorationImage(
              //image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/dartfinalproject.appspot.com/o/Users%2Fal188067%40edu.uaa.mx?alt=media&token=adccf315-1b53-481a-8ffc-65b81279fe2c'),
              image: NetworkImage(doc.Image),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xffA4A4A4),
                offset: Offset(1.0, 5.0),
                blurRadius: 3.0,
              )
            ]
        ),
      ),
    );
  }
  void userList(String? searchText){
    setState((){
      if(listUser != null){
        if(searchText == null || searchText==""){
          _users = Column(
            children: listUser.map((user) => buildItem(user)).toList(),
          );
        }else{
          var usuario = listUser.where((element) => element.Nombre.startsWith(searchText)).toList();
          if(0 < usuario.length){
            _users = Column(
              children: usuario.map((user) => buildItem(user)).toList(),
            );
          }else{
            _users = SizedBox();
          }
        }
      }else{
        _users = SizedBox();
      }
    });
  }
  void searchOperation(String? searchText){
    if(_isSearching == true){
      userList(searchText);
    }
  }
  void _handleSearchStart(){
    setState(() {
      _isSearching = true;
    });
  }
  void _handleSearchEnd(){
    setState((){
      this.icon = Icon(
        Icons.search,
        color:Colors.white,
      );
      this.appBarTitle = Text(
        "Search user",
        style: new TextStyle(color:Colors.white),
      );
      _controller.clear();
      _isSearching = true;
    });
  }

}