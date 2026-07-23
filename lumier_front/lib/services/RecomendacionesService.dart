import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:lumier_front/models/Peliculas.dart';

class RecomendacionesService {
  final String baseUrl = 'http://10.0.2.2:8080/api/recomendaciones';

  Future<List<Pelicula>> obtenerRecomendaciones(int userId) async {
    final url = Uri.parse("$baseUrl/$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        List<Pelicula> data = jsonList
            .map((x) => Pelicula.fromJson(x))
            .toList();

        return data;
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Fallo de conexión al traer recomendaciones: $e");
    }
  }
}
