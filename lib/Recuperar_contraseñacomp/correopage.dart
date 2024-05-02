import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<Map<String, dynamic>> sendRecuperacionPassword(String username) async {
    final url =
        Uri.parse('$baseUrl/auth/email/sendRecuperacionPassword/$username');
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
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
        return 'Password changed successfully';
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
