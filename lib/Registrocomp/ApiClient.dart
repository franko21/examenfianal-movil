import 'package:http/http.dart' as http;
import 'dart:convert';

class Employee {
  final int? id;
  final String? name;
  final String? username;
  final String? role;

  Employee({this.id, this.name, this.username, this.role});

  factory Employee.fromJson(Map<String, dynamic>? json) {
    return Employee(
      id: json?['idEmpleado'],
      name: json?['nombre'],
      username: json?['username'],
      role: json?['role'],
    );
  }
}

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
          'role': rol,
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

  Future<String> signinUser(
      String username, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v2/signin'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        // Registro exitoso
        final rolB = json.decode(response.body)['empleado']['role'];
        final nombreB = json.decode(response.body)['empleado']['nombre'];
        final apellidoB = json.decode(response.body)['empleado']['apellido'];
        print('Usuario logeado exitosamente. Rol: $rolB');
        role = rolB.toString();

        return '$rolB $nombreB $apellidoB';
      } else {
        // Manejar errores de registro
        print(
            'Error en el inicio de sesión:  ${response.statusCode} ${response.toString()}');
        return '';
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return '';
    }
  }

  Future<void> dataTableE(
      List<String> _dataList, String fechaI, String fechaF) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl2/$fechaI/$fechaF'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        _dataList = stringList.map((element) => element.toString()).toList();
        // Procesa la respuesta JSON y actualiza _dataList
        // Ejemplo: _dataList = MyDataModel.fromJson(response.body);
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/$fechaI/$fechaF');
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
    }
  }
}
