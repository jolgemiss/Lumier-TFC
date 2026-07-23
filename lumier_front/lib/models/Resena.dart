class Resena {
  final String usuarioNombre;
  final String comentario;
  final double puntuacion;
  final String fecha;

  Resena({
    required this.usuarioNombre,
    required this.comentario,
    required this.puntuacion,
    required this.fecha,
  });

  factory Resena.fromJson(Map<String, dynamic> json) {
    return Resena(
      usuarioNombre: json['usuario']['nombreUsuario'] ?? 'Usuario anónimo',
      comentario: json['comentario'] ?? '',
      puntuacion: (json['puntuacion'] as num).toDouble(),
      fecha: json['fechaPublicacion'] ?? '',
    );
  }
}
