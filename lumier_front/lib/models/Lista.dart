class Lista {
  final int? id;
  final int idUsuario;
  final String nombreLista;
  final String descripcion;
  final String fechaRegistro;

  Lista({
    this.id,
    required this.idUsuario,
    required this.nombreLista,
    required this.descripcion,
    required this.fechaRegistro,
  });

  // 1. Para el GET: Recibes JSON de la API
  factory Lista.fromJson(Map<String, dynamic> json) {
    print('JSON recibido: $json');
    return Lista(
      id: json['id'],
      idUsuario: json['idUsuario'],
      nombreLista: json['nombreLista'],
      descripcion: json['descripcion'],
      // Si la API lo envía como null, puedes poner un valor por defecto: ?? ""
      fechaRegistro: (json['fechaCreacion'] ?? "").toString().split('T')[0],
    );
  }

  // 2. Para el POST: Conviertes el objeto a JSON para enviarlo a la API
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombreLista': nombreLista,
      'descripcion': descripcion,
      'fechaCreacion': fechaRegistro, // Añadido al JSON de envío
    };
  }
}
