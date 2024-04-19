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
      'http://10.0.2.2:8080/api/personnelE/iclockT/fecha/v2';
  static const String baseUrl3 = 'http://10.0.2.2:8080/api/userinfo/v2';
  static const String baseUrl4 = 'http://10.0.2.2:8080/departamentos/v2';

  Future<String> existeEmpleado(String cedula) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl3/$cedula'),
      );
      if (response.statusCode == 200) {
        // Registro exitoso
        final List<dynamic> stringList = json.decode(response.body);
        List<String> _dataList2 =
            stringList.map((element) => element.toString()).toList();
        if (_dataList2.length == 0) {
          return '';
        } else {
          print('Empleado existe');
          return 'existe';
        }
      } else {
        // Manejar errores de registro
        print('Error: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return '';
    }
  }

  Future<bool> registerUser(String email, String password, String nombre,
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
        return true;
      } else {
        // Manejar errores de registro
        print('Error en el registro: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return false;
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
        final cedulaB = json.decode(response.body)['empleado']['dni'];
        print('Usuario logeado exitosamente. Rol: $rolB');
        role = rolB.toString();

        return '$rolB $nombreB $apellidoB $cedulaB';
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

  Future<List<String>> dataTableE(String fechaI, String fechaF) async {
    List<String> _dataList2;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl2/$fechaI/$fechaF'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        List<String> _dataList2 =
            stringList.map((element) => element.toString()).toList();
        print('Exito -> $baseUrl2/$fechaI/$fechaF');
        // String a = _dataList2.toString();
        // print('$_dataList2');
        return _dataList2;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/$fechaI/$fechaF');
        return _dataList2 = [];
        ;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return _dataList2 = [];
    }
  }

  Future<List<String>> dataTableET(
      String fechaI, String fechaF, String emp_code) async {
    List<String> _dataList2;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl2/$emp_code/$fechaI/$fechaF'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        List<String> _dataList2 =
            stringList.map((element) => element.toString()).toList();
        print('Exito -> $baseUrl2/$emp_code/$fechaI/$fechaF');
        // String a = _dataList2.toString();
        // print('$_dataList2');
        return _dataList2;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/$emp_code/$fechaI/$fechaF');
        return _dataList2 = [];
        ;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return _dataList2 = [];
    }
  }

  Future<List<String>> departamentos() async {
    List<String> _dataList2;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl4'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        List<String> _dataList2 =
            stringList.map((element) => element.toString()).toList();
        print('Exito -> $baseUrl4');
        // String a = _dataList2.toString();
        // print('$_dataList2');
        return _dataList2;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl4');
        return _dataList2 = [];
        ;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return _dataList2 = [];
    }
  }
}
