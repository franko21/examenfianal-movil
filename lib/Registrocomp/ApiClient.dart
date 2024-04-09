import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://localhost:8080/auth';

  Future<void> registerUser(String email, String password, String nombre,
      String apellido, String dni) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {
          'email': email,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
          'dni': dni,
        },
      );
      if (response.statusCode == 200) {
        // Registro exitoso
        print('Usuario registrado exitosamente');
      } else {
        // Manejar errores de registro
        print('Error en el registro: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
    }
  }
}
