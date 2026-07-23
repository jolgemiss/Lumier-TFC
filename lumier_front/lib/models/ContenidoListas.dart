class ContenidoListasDTO {
  
  final int tmdbId;
  final int idLista;
  final String titulo;
  final String urlPoster;

  ContenidoListasDTO({
    required this.tmdbId,
    required this.idLista,
    required this.titulo,
    required this.urlPoster,
  });
  

  Map<String, dynamic> toJson() {
    return {
      'tmdbId': tmdbId,
      'idLista': idLista,
      'titulo': titulo,
      'urlPoster': urlPoster
    };
  }
}