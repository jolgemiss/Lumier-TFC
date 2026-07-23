import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lumier_front/models/Peliculas.dart';

import '../models/Resena.dart';

class PeliculaService {

  final String baseUrl = 'http://10.0.2.2:8080/api/movies';

  // OBTENER LISTAS (Populares, Top Rated, Now Playing)
  Future<List<Pelicula>> getMovies(String endpoint) async {
    final url = Uri.parse('$baseUrl/lista/$endpoint');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        return decodedData.map((item) => Pelicula.fromJson(item)).toList();
      } else {
        throw Exception('Fallo al cargar pelis desde Java');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<String?> publicarResena({
    required int tmdbId,
    required String tituloPelicula,
    required int usuarioId,
    required String comentario,
    required double puntuacion,
    required String urlPoster, // <--- Este argumento ya lo recibes
  }) async {
    final url = Uri.parse('$baseUrl/resena');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'comentario': comentario,
          'puntuacion': puntuacion,
          'usuarioId': usuarioId,
          'tmdbId': tmdbId,
          'tituloPelicula': tituloPelicula,
          // --- AÑADE ESTA LÍNEA ---
          'urlPoster': urlPoster.isNotEmpty
              ? urlPoster
              : 'https://via.placeholder.com/500',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['message'] ?? "Reseña guardada con éxito";
      } else {
        print("Error del servidor: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error de red: $e");
      return null;
    }
  }

  // OBTENER LA LISTA DE RESEÑAS DE LA PELÍCULA SELECCIONADA
  Future<List<Resena>> obtenerResenas(int tmdbId) async {
    final url = Uri.parse('$baseUrl/resenas/$tmdbId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Resena.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Error al obtener reseñas: $e");
      return [];
    }
  }

  Future<List<Pelicula>> buscarPeliculas(String query) async {
    final url = Uri.parse(
      '$baseUrl/buscar?query=${Uri.encodeComponent(query)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Pelicula.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // OBTENER LISTAS POR GÉNERO (Acción, Aventura, etc.)
  Future<List<Pelicula>> getGenreMovies(int idGenero) async {
    final url = Uri.parse('$baseUrl/genero/$idGenero');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        return decodedData.map((item) => Pelicula.fromJson(item)).toList();
      } else {
        throw Exception('Fallo al cargar pelis desde Java');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // OBTENER SUPERHÉROES
  Future<List<Pelicula>> getSuperheroMovies() async {
    final url = Uri.parse('$baseUrl/superheroes');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pelicula.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar superhéroes');
    }
  }

  // OBTENER EL LOGO (URL directa)
  Future<String?> getMovieLogo(int movieId) async {
    final url = Uri.parse('$baseUrl/$movieId/logo');

    try {
      final response = await http.get(url);
      // Java devuelve la URL plana, no un JSON, por eso usamos response.body directamente
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body;
      }
    } catch (e) {
      print("Error cargando logo: $e");
    }
    return null;
  }

  // OBTENER DETALLES
  Future<Pelicula> getMovieDetails(int movieId) async {

    final url = Uri.parse('$baseUrl/$movieId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Pelicula.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al cargar detalles de la película');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
