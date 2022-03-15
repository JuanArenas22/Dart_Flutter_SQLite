

import 'dart:ui';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:miflutter/add_users.dart';
import 'package:miflutter/models/Usuario.dart';

import 'data/DBHelper.dart'; //importamos esta linea de codigo para tener librerias que nos ayudan con flutter

void main() => runApp(MyApp());//para ejecutar la aplicacion******************************************

class MyApp extends StatelessWidget {
//prueba para saber si subio el proyecto

  // extends de uns libreria que nos permitira muchas cosas de flutter
  @override
  //implementamos nuestra interfax de usuario con este metodo
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner:
            false, //con esta linea le quitamos la etiqueta que sale en el emulador de DEBUG
        title: "Curso de dart",
        theme: ThemeData(
          //aqui le proporcionamos el color de fondo que le pondremos a la app
          primarySwatch: Colors.deepOrange, //color
        ),
        home: HomePageMain() ,//titulo que llevara la aplicacion al ejecutarse
      routes: <String, WidgetBuilder>{
        '/MyApp': (BuildContext context) => MyApp(),
          '/add_users': (BuildContext context) => add_users(null),
      },
        );
  }
}

class HomePageMain extends StatefulWidget {
  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<HomePageMain> {
  String title = 'Curso de Dart';
  DBHelper _dbHelper = DBHelper();
  Widget _users = SizedBox();
  Widget appBarTitle = Text(
    "Search user",
    style: TextStyle(color: Colors.white),
  );
  Icon icon = Icon(
    Icons.search,
    color: Colors.white,
  );
  bool? _isSearching;
  BuildContext? _context;
  final TextEditingController _controller = new TextEditingController();

  MyHomePage() {
    userList(null);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _context = context;
    return Scaffold(
      appBar: AppBar(
        //aqui podemos agregarle lo que queramos a nuestra app
        title: appBarTitle,
        actions: <Widget>[
          IconButton(//icono que nos permite buscar un usuario
            icon: icon,
            onPressed: () {
              setState(() {
                //metodo que le permite a flutter que se realizo un cambio
                if (this.icon.icon == Icons.search) {
                  this.icon = Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = TextField(
                    controller: _controller,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white)
                    ),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                }else{
                  searchOperation(null);
                  _handleSearchEnd();
                }
              });
            },
          ),
          //con esta opcion podemos tener librerias para agregar
          IconButton(
            //un icono
            icon: Icon(
              //aqui podemos decirle que queremos un icono
              Icons.add, //aqui podemos decirle que tipo de icono queremos que se agregue en este caso el de Añador +
              color: Colors.white, //le proporcionamos un color
            ),
            onPressed: ()=> {
              Navigator.of(context).pushNamed('/add_users'),
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[_users],
      ),
    );
  }

  Container buildItem(Usuario doc) {
    return Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      child: Stack(
        children: <Widget>[
          card(doc),
        ],
      ),
    );
  }
//tarjetas
  GestureDetector card(Usuario doc) {
    return GestureDetector(
      onLongPress: (){//aqui le decimos que podemos presionar la tarjeta por un corto tiempo para eliminar y llamamos el metodo (_ackAlert)
        _ackAlert(doc);
      },
      onTap: (){//este evento nos permite selecionar la tarjeta
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext contex) =>
          add_users(doc)));
      },
      child: Container(
        height: 124.0,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
              offset: Offset(0.0, 5.0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${doc.nombre}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              Text(
                '${doc.apellido}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//metodo que nos permite saber si se va a buscar algun usuario
  void _handleSearchStart(){
    setState(() {
      _isSearching = true;
    });
  }
//metodo que nos permite cancelar si no vamos a buscar algun usuario
  void _handleSearchEnd(){
    setState(() {
      this.icon = Icon(
        Icons.search,
        color:  Colors.white,
      );
      this.appBarTitle = Text(
        "Search user",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String? searchText){
    if(_isSearching == true){
      userList(searchText);
    }
  }


//es te metodo nos permite tener una lista de usuarios
  Future userList(String? searchText) async {
    List<Usuario> listUsuario = await _dbHelper.getUsuarios();
    setState(() {
      if (listUsuario != null) {
        if (searchText == null || searchText == "") {
          _users = Column(
              children: listUsuario.map((user) => buildItem(user)).toList());
        }else{
          var usuario = listUsuario.where((item) =>item.nombre!.startsWith(searchText)).toList();
          if(0 < usuario.length){
            _users = Column(
            children: usuario.map((user) => buildItem(user)).toList()
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
//metodo que nos permite eliminar la tarjeta cuando la mantenemos precionada
  Future<void> _ackAlert(Usuario user){
    return showDialog<void>(
      context: _context!,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content: Text('Esta seguro de eliminar el siguiente usuario ${user.nombre}'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                await _dbHelper.deleteUser(user.id!);
                userList(null);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}
