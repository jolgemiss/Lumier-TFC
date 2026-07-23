class InteraccionRequestDto {
  final int idUsuario;
  final int tmdbId;
  final String tipoAccion;
  final String tituloPelicula;
  final String urlPoster;

  InteraccionRequestDto({
    required this.idUsuario,
    required this.tmdbId,
    required this.tipoAccion,
    required this.tituloPelicula,
    required this.urlPoster,
  });

  // Convierte el objeto DTO en un Map listo para pasárselo a jsonEncode
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'tmdbId': tmdbId,
      'tipoAccion': tipoAccion,
      'tituloPelicula': tituloPelicula,
      'urlPoster': urlPoster,
    };
  }
}
