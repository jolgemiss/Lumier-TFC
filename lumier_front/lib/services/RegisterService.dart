import 'dart:convert';
import 'package:http/http.dart' as http;


class RegisterService {
  Future<String?> enviarRegistro(
    String nombre,
    String apellidos,
    String email,
    String username,
    String password,
  ) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/usuarios/registro');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'apellidos': apellidos,
          'email': email,
          'nombreUsuario': username,
          'contrasena': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // Todo OK, no hay error
      } else {
        return response.body; // Devolvemos el error que mandó Spring Boot
      }
    } catch (e) {
      return "Error de conexión: No se pudo contactar con el servidor.";
    }
  }
}
