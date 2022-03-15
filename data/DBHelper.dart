


import 'package:flutter/cupertino.dart';
import 'package:miflutter/main.dart';
import 'package:miflutter/models/Usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
//import 'dart:html';
import 'package:path/path.dart';

class DBHelper{
  static Database? _db;
  Future<Database?> get database async{
    if(_db != null) return _db;
    _db = await initDB();
    return _db;
  }
  Future<Database?> initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'basedatos.db');
    Database db = await openDatabase(
    path,
    version: 1,
    onCreate: _createTables,
    );
    print('[DBHelper] initDB: Success');
    return db;
  }

  void _createTables (Database db, int version) async{
    await db.execute(
      'CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, apellido TEXT, email TEXT)',
    );
  }
//metodo que nos ayudara a insertar los datos del usuario
  Future<void> insertUser(Usuario user,BuildContext context) async {
    //obtiene la referencua de la base de datos
    final Database? db = await database;
    //obtiene el user en la tabla correcta. Tambien puede especificar el
    //confictAlgorithm para usar en caso de que el mismo user se inserte dos veces
    //En este caso, reemplaza cualquier dato anterior
    await db?.insert(
    'User',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((int value) {
      Navigator.of(context).push(PageRouteBuilder(//aqui decimos que vamos a navegar del siguiente interfaz inicio hacia una nueva ruta
          pageBuilder:(_,__,____)=>MyApp()));//nueva ruta que es la clase

    });
  }
 //Metodo BUSCAR A LA DB
  //este metodo recupera todos los user de la tabla user
  Future<List<Usuario>> getUsuarios() async{
    final Database? db = await database;

    final List<Map<String, dynamic>>? maps = await db?.query('User');
    return List.generate(maps!.length, (i) {
      return Usuario(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        apellido: maps[i]['apellido'],
          email: maps[i]['email']
      );
    });

  }

  Future<void> deleteUser(int id) async{
    //obtiene una referencia de la base de datos
    final db = await database;
    await db!.delete(
      'User',
      //utiliza la clausula 'where' para eliminar un usuario especifico
      where: "id = ?",
      whereArgs: [id],
    );

  }

  Future<void> updateUser(Usuario user) async {
    //obtiene la referencua de la base de datos
    final Database? db = await database;

    await db?.update(
      'User',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }



}


