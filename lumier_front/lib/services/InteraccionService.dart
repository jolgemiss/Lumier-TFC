import 'dart:convert';
import 'package:http/http.dart' as http;

class InteraccionService {
  final String baseUrl = "http://10.0.2.2:8080/interacciones";

  Future<bool> toggleInteraccion({
    required int idUsuario,
    required int tmdbId,
    required String tipoAccion,
    required String tituloPelicula,
    required String urlPoster,
  }) async {
    final url = Uri.parse("$baseUrl/toggle");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idUsuario": idUsuario,
          "tmdbId": tmdbId,
          "tipoAccion": tipoAccion,
          "tituloPelicula": tituloPelicula,
          "urlPoster": urlPoster,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> respuesta = jsonDecode(response.body);
        print("Backend dice: ${respuesta['mensaje']}");
        return respuesta['status'] == 'guardado';
      } else {
        print(
          "Error en el servidor: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Error de conexión al gestionar interacción: $e");
      return false;
    }
  }
}
