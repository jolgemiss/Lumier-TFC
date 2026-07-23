class UsuarioPerfil {
  final String nombre;
  final String apellidos;
  final String nombreUsuario;
  final String urlAvatar;
  String biografia;
  final String fechaRegistro;
  final int totalVistas;
  final int totalFavoritos;

  UsuarioPerfil({
    required this.nombre,
    required this.apellidos,
    required this.nombreUsuario,
    required this.urlAvatar,
    required this.biografia,
    required this.fechaRegistro,
    required this.totalVistas,
    required this.totalFavoritos,
  });

  // Factory para convertir el JSON de Spring Boot a objeto Dart
  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) {
    return UsuarioPerfil(
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      nombreUsuario: json['nombreUsuario'] ?? '',
      urlAvatar: json['urlAvatar'] ?? 'https://i.pravatar.cc/150',
      biografia: json['biografia'] ?? 'Sin biografía.',
      fechaRegistro: json['fechaRegistro'] ?? '',
      totalVistas: json['totalVistas'] ?? 0,
      totalFavoritos: json['totalFavoritos'] ?? 0,
    );
  }
}