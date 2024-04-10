import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8080/auth';
  static const String baseUrl2 =
      'http://10.0.2.2:8080/api/personnelE/iclockT/fecha';

  Future<void> registerUser(String email, String password, String nombre,
      String apellido, String dni, String rol, String idDepartamento) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
          'dni': dni,
          'rol': rol,
          'idDepartamento': idDepartamento,
        }),
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

  Future<void> signinUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v1/signin'),
        body: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        // Registro exitoso
        print('Usuario logeado exitosamente');
      } else {
        // Manejar errores de registro
        print('Error en el inicio de sesión: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
    }
  }

  Future<void> dataTableE(
      List<String> _dataList, String fechaI, String fechaF) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl2/$fechaI/$fechaF'));

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        _dataList = stringList.map((element) => element.toString()).toList();
        // Procesa la respuesta JSON y actualiza _dataList
        // Ejemplo: _dataList = MyDataModel.fromJson(response.body);
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
    }
  }
}
