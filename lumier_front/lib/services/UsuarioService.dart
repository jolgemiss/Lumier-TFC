import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/UsuarioPerfil.dart';

class UsuarioService {
  final String baseUrl = 'http://10.0.2.2:8080/api/usuarios';

  Future<UsuarioPerfil> getUser(int idUsuario) async {
    final url = Uri.parse('$baseUrl/perfil/$idUsuario');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return UsuarioPerfil.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el perfil: ${response.statusCode}');
    }
  }

  Future<void> actualizarBiografia(int userId, String nuevaBiografia) async {
    final url = Uri.parse('$baseUrl/biografia/$userId');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"biografia": nuevaBiografia})
      );

      if (response.statusCode != 200) {
        throw Exception("Error del servidor al actualizar la biografía: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexion con el backend: $e");
    }
  }
}
