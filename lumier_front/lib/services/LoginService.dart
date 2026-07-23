import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lumier_front/globales.dart';

class Loginservice {
  Future<String?> enviarLogin(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/usuarios/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'contrasena': password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        userIdLogueado = data['id'];
        
        return null; // Todo OK, no hay error
      } else {
        return response.body; // Devolvemos el error que mandó Spring Boot
      }
    } catch (e) {
      throw Exception('Error al enviar el login');
    }
  }
}
