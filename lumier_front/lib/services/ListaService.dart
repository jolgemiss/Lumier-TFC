import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lumier_front/models/ContenidoListas.dart';
import 'package:lumier_front/models/Lista.dart';

import '../models/Peliculas.dart';

class Listaservice {
  final String baseUrl = 'http://10.0.2.2:8080/api/listas';

  Future<List<Lista>> obtenerListas(int idUsuario) async {
    final url = Uri.parse('$baseUrl/$idUsuario');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        return decodedData.map((item) => Lista.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar listas desde Java');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // POST: Crear una nueva lista
  Future<void> crearLista(Lista nuevaLista) async {
    final url = Uri.parse(
      '$baseUrl/crear',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          nuevaLista.toJson(),
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Éxito: la lista se ha creado en el servidor
        print('Lista creada con éxito');
      } else {
        throw Exception('Error al crear la lista: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<void> agregarPeliculaLista(ContenidoListasDTO contenidoLista) async {
    final url = Uri.parse(
      '$baseUrl/agregarPelicula',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contenidoLista.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Película añadida con éxtio');
      } else {
        throw Exception('Error al añadir la película: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<List<Pelicula>> obtenerPeliculasDeLista(int listaId) async {
    final url = Uri.parse('$baseUrl/$listaId/peliculas');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonDecodificado = jsonDecode(response.body);

        return jsonDecodificado.map((item) => Pelicula.fromJson(item)).toList();
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión con el backend: $e");
    }
  }
}
