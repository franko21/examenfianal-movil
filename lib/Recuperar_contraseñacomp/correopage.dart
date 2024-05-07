import 'dart:convert';
import 'dart:io'; // Importa 'dart:io' para manejar SocketException

import 'package:http/http.dart' as http;

class EmailService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final String base2 = 'http://localhost:8080';

  Future<Map<String, dynamic>> sendRecuperacionPasswordByUsername(
      String username) async {
    final url =
        Uri.parse('$baseUrl/auth/email/sendRecuperacionPassword/$username');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to send recovery email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e'); // Manejo genérico de errores
    }
  }

  Future<bool> existeUsuario(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/existe/$email'));
      final bool exists = jsonDecode(response.body);
      print(
          'Solicitud de verificación de existencia de usuario enviada: $email');
      print('Respuesta recibida: $exists');
      return exists;
    } on SocketException catch (e) {
      // Manejo específico de SocketException
      print('Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    } on HttpException catch (e) {
      // Manejo específico de HttpException
      print('Error HTTP: $e');
      throw Exception('Error HTTP: $e');
    } on FormatException catch (e) {
      // Manejo específico de FormatException (JSON mal formado)
      print('JSON mal formado: $e');
      throw Exception('JSON mal formado: $e');
    } catch (e) {
      // Manejo genérico de otros errores
      print('Error al verificar la existencia del usuario: $e');
      throw Exception('Error al verificar la existencia del usuario: $e');
    }
  }

  Future<Map<String, dynamic>> sendRecuperacionPasswordByEmail(
      String email) async {
    final url =
        Uri.parse('$baseUrl/auth/email/sendRecuperacionPassword/$email');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body); // Devuelve un Map<String, dynamic>
      } else {
        throw Exception('Failed to send recovery email');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class CambiarContraseniaService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<String> cambiarContraseniaUsuario(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/auth/cambiarContraseniaUsuario');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return 'Contraseña cambiada exitosamente';
      } else {
        throw Exception(
            'Error al cambiar la contraseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cambiar la contraseña: $e');
    }
  }
}
