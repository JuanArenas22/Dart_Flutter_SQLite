import 'dart:ui';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:miflutter/data/DBHelper.dart';
import 'package:miflutter/main.dart';
import 'package:miflutter/models/Usuario.dart'; //importamos esta linea de codigo para tener librerias que nos ayudan con flutter

//clase principal
class add_users extends StatelessWidget {
  Usuario? _user;
//contructor que puede recibir como paramero un usuario
  add_users(this._user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //con esta linea le quitamos la etiqueta que sale en el emulador de DEBUG
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: <String, WidgetBuilder>{
        '/add_users': (BuildContext context) => add_users(null),
        '/MyApp': (BuildContext context) => MyApp(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registrar'),
          leading: IconButton(
            icon: Icon(
              //aqui podemos decirle que queremos un icono
              Icons
                  .arrow_back_ios, //aqui podemos decirle que tipo de icono queremos que se agregue en este caso el de Añador +
              color: Colors.white, //le proporcionamos un color
            ),
            onPressed: () => {
              Navigator.of(context).pushReplacementNamed('/MyApp'),
            },
          ),
        ),
        body: UserForm(_user),
      ),
    );
  }
}
//esta clase queda como referencia ya que esdtamos simplificando el codigo
/*class AddUser extends StatelessWidget {

  final String title;
  AddUser({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(
            //aqui podemos decirle que queremos un icono
            Icons
                .arrow_back_ios, //aqui podemos decirle que tipo de icono queremos que se agregue en este caso el de Añador +
            color: Colors.white, //le proporcionamos un color
          ),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
              //aqui decimos que vamos a navegar del siguiente interfaz inicio hacia una nueva ruta
              pageBuilder: (_, __, ____) =>
                  MyApp(), //nueva ruta que es la clase
            ));
          },
        ),
      ),
      body: UserForm(),
    );
  }
}
 */

class UserForm extends StatefulWidget {
  Usuario? _user;
  UserForm(this._user);
  @override
  UserFormState createState() {
    return UserFormState(_user);
  }
}

class UserFormState extends State<UserForm> {
  Usuario? _user;
  final _formKey = GlobalKey<FormState>(); //creamos una llave global
  var _nombre =
      TextEditingController(); //creamos los objetos para poder obtener la informacion
  var _apellido = TextEditingController();
  var _email = TextEditingController();

  UserFormState(this._user) {
    if (_user != null) {
      _nombre.text = _user!.nombre!;
      _apellido.text = _user!.apellido!;
      _email.text = _user!.email!;
    }
  }

  var _lista = ['carro', 'casa', 'vaca'];
  String _vista = "Seleccione una opcion";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      //retornamos el formulario
      key: _formKey, //llave del formulario
      child: ListView(
        //Un hijo y un lista que nos permite almacenar colecciones de objetos
        children: <Widget>[
          Padding(
            //desde el paddin podemos agregar el text y se pueden hacer mas copiuando y pegando debajo del padin
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 10.0), //damos la medidas del paddin
            child: TextFormField(
              //al hijo le creamos un formulario
              keyboardType: TextInputType
                  .text, //decimos que lo queremos de tipo Text pero se pueden de otros tipos
              style: TextStyle(fontSize: 20.0), //le damos un estilo
              decoration: InputDecoration(
                //en la decoracion
                labelText:
                    "Ingrese el Nombre", //ponemos una descripcion dentro del text y que cuando vamos a editar se pase hacia arriba
                prefixIcon: Icon(Icons
                    .person), //le asignamos un icono al text de tipo persona
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      25.0), //damos un estilo de borde para el text
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Porfavor ingrese el nombre';
                }
              },
              controller: _nombre,
            ),
          ),
          Padding(
            //desde el paddin podemos agregar el text y se pueden hacer mas copiuando y pegando debajo del padin
            padding: const EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 10.0), //damos la medidas del paddin
            child: TextFormField(
              //al hijo le creamos un formulario
              keyboardType: TextInputType
                  .text, //decimos que lo queremos de tipo Text pero se pueden de otros tipos
              style: TextStyle(fontSize: 20.0), //le damos un estilo
              decoration: InputDecoration(
                //en la decoracion
                labelText:
                    "Ingrese el Apellido", //ponemos una descripcion dentro del text y que cuando vamos a editar se pase hacia arriba
                prefixIcon: Icon(Icons
                    .person), //le asignamos un icono al text de tipo persona
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      25.0), //damos un estilo de borde para el text
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Porfavor ingrese el apellido';
                }
              },
              controller: _apellido,
            ),
          ),
          Padding(
            //desde el paddin podemos agregar el text y se pueden hacer mas copiuando y pegando debajo del padin
            padding: const EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 10.0), //damos la medidas del paddin
            child: TextFormField(
              //al hijo le creamos un formulario
              keyboardType: TextInputType
                  .emailAddress, //decimos que lo queremos de tipo Text pero se pueden de otros tipos
              style: TextStyle(fontSize: 20.0), //le damos un estilo
              decoration: InputDecoration(
                //en la decoracion
                labelText:
                    "Ingrese el Email", //ponemos una descripcion dentro del text y que cuando vamos a editar se pase hacia arriba
                prefixIcon: Icon(Icons
                    .email), //le asignamos un icono al text de tipo persona
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      25.0), //damos un estilo de borde para el text
                ),
              ),
              validator: (value) {
                //con este metodo validamos que los campos esten llenos si no retornamos un mensaje
                if (value!.isEmpty) {
                  return 'Porfavor ingrese el Email';
                }
              },
              controller: _email,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            child: MaterialButton(
              //con esta clase podemos agregar un boton*************
              minWidth: 200.0, //le damos sus respectivas medidas
              height: 60.0,
              onPressed: () {
                //aqui tenemos el evento que va a realizar el boton
                if (_formKey.currentState!.validate()) {
                  var dbHelper = DBHelper();
                  if (_user == null) {
                    dbHelper.insertUser(
                        Usuario(
                            nombre: _nombre.text,
                            apellido: _apellido.text,
                            email: _email.text),
                        context);
                  } else {
                    _user!.nombre = _nombre.text;
                    _user!.apellido = _apellido.text;
                    _user!.email = _email.text;
                    dbHelper.updateUser(_user!);
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/MyApp', ModalRoute.withName('/MyApp'));
                }
              },
              color: Colors.green, //un color para el boton
              child: Text(
                "Registrar", //una descripcion para el boton
                style: const TextStyle(
                  color: Colors.white, //el color de la letra del boton
                  fontSize: 20,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
