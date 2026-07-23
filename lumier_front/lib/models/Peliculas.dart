class Pelicula {
  final int id;
  final String posterPath;
  // Campos opcionales para cuando solo cargamos datos básicos (carrusel)
  final String titulo;
  final String backdropPath;
  final String overview;
  final String releaseDate;
  final int runtime;
  final String originalLanguage;
  final String logoUrl;
  final List<String> generos;
  final double voteAverage;

  Pelicula({
    required this.id,
    required this.posterPath,
    this.titulo = 'Sin título',
    this.backdropPath = '',
    this.overview = 'Sinopsis no disponible',
    this.releaseDate = 'N/A',
    this.runtime = 0,
    this.originalLanguage = 'N/A',
    this.logoUrl = '',
    this.generos = const [],
    this.voteAverage = 0.0,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    // Helper para construir la URL de imagen solo si existe el path
    String buildImageUrl(String? path) =>
        path != null ? 'https://image.tmdb.org/t/p/w500$path' : '';

    return Pelicula(
      id: json['id'],
      posterPath: buildImageUrl(json['poster_path']),
      titulo: json['title'] ?? 'Sin título',
      backdropPath: buildImageUrl(json['backdrop_path']),
      overview: json['overview'] ?? 'Sinopsis no disponible',
      releaseDate: json['release_date'] ?? 'N/A',
      runtime: json['runtime'] ?? 0,
      originalLanguage: json['original_language'] ?? 'N/A',
      logoUrl: buildImageUrl(json['logo_path']),
      generos: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}