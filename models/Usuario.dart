class Usuario{

  int? id;
  String? nombre;
  String? apellido;
  String? email;

  Usuario({this.id,this.nombre,this.apellido,this.email});

  Map<String, dynamic> toMap(){
      return {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
      };
  }
}