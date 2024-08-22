import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
  static const String baseUrl0 = 'http://10.0.2.2:8080/api';
  static const String baseUrl = 'http://10.0.2.2:8080/auth';
  static const String baseUrl2 =
      'http://10.0.2.2:8080/api/personnelE/iclockT/fecha/v2';
  static const String baseUrl3 = 'http://10.0.2.2:8080/api/userinfo/v2';
  static const String baseUrl4 = 'http://10.0.2.2:8080/departamentos/v2';
  static const String baseUrl5 = 'http://10.0.2.2:8080/odo';

  Future<List<String>> dataTablePersonas() async {
    List<String> personaStringList = [];
    try {
      final response = await http.get(
        Uri.parse('$baseUrl0/persona'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        // Convertir directamente la lista de mapas (JSON) en una lista de Strings
        personaStringList = jsonList.map((json) {
          // Suponiendo que cada elemento es un mapa con claves como 'id', 'nombre', 'apellido'
          return 'ID: ${json['id']}, Nombre: ${json['nombre']}, Apellido: ${json['apellido']}, Cedula: ${json['cedula']}';
        }).toList();

        print('$baseUrl0/persona');
        return personaStringList;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl0/persona');
        return personaStringList;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return personaStringList;
    }
  }

  Future<String> existeEmpleado(String cedula) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl3/$cedula'),
      );
      if (response.statusCode == 200) {
        // Registro exitoso
        final List<dynamic> stringList = json.decode(response.body);
        List<String> dataList2 =
            stringList.map((element) => element.toString()).toList();
        if (dataList2.isEmpty) {
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
      String apellido, String dni, String role, String idDepartamento) async {
    try {
      print('Datos enviados en la solicitud:');
      print('Email: $email');
      print('Password: $password');
      print('Nombre: $nombre');
      print('Apellido: $apellido');
      print('DNI: $dni');
      print('Rol: $role');
      print('ID Departamento: $idDepartamento');

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
          'role': role, // Utiliza el rol pasado como parámetro
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

  // Future<String> signinUser(
  //     String username, String password, String role) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/v2/signin'),
  //       body: {
  //         'username': username.replaceAll(RegExp(r'^0+'), ''),
  //         'password': password
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // Registro exitoso
  //       final rolB = json.decode(response.body)['empleado']['role'];
  //       final nombreB = json.decode(response.body)['empleado']['nombre'];
  //       final apellidoB = json.decode(response.body)['empleado']['apellido'];
  //       final cedulaB = json.decode(response.body)['empleado']['dni'];
  //       print('Usuario logeado exitosamente. Rol: $rolB');
  //       role = rolB.toString();

  //       return '$rolB $nombreB $apellidoB $cedulaB';
  //     } else {
  //       // Manejar errores de registro
  //       print(
  //           'Error en el inicio de sesión:  ${response.statusCode} ${response.toString()}');
  //       return '';
  //     }
  //   } catch (e) {
  //     // Manejar errores de conexión
  //     print('Error de conexión: $e');
  //     return '';
  //   }
  // }
  Future<String> signinUser(String username, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl0/admin/$username/$password'),
      );

      if (response.statusCode == 200) {
        // La respuesta es true si las credenciales son correctas
        if (response.body == 'true') {
          // Puedes personalizar esta parte para manejar la respuesta correcta
          print('Usuario logeado exitosamente.');
          return 'Login exitoso';
        } else {
          // Credenciales incorrectas
          print('Credenciales incorrectas');
          return '';
        }
      } else {
        // Manejar otros errores HTTP
        print('Error en el inicio de sesión: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return '';
    }
  }

  Future<List<String>> dataTableVent() async {
    List<String> dataList2;
    List<String> dataList3;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl5/datosoVentas'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<String> dataList = responseData.map((item) {
          return '${item['id']}, '
              '${item['product_template_id'][1]}, '
              '${item['name']}, '
              '${item['product_uom_qty']}, '
              '${item['qty_delivered']}, '
              '${item['qty_invoiced']}, '
              '${item['product_uom'][1]}, '
              '${item['price_unit']}, '
              '${item['tax_id'].isEmpty ? 'None' : item['tax_id'].join(', ')}, '
              '${item['discount']}, '
              '${item['price_subtotal']}';
        }).toList();
        // Aquí asumo que los valores del mapa son cadenas
        dataList2 = responseData.map((value) => value.toString()).toList();

        print('Exito -> $baseUrl5/datosoVentas');
        return dataList;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/datosoVentas');
        return [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return [];
    }
  }

  Future<List<String>> dataTablePagos(String fac) async {
    List<String> dataList2;
    List<String> dataList3;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl5/datosoPagos/$fac'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<String> dataList = responseData.map((item) {
          return '${item['name']}, '
              '${item['ref']}, '
              '${item['partner_id'][1]}, '
              '${item['date']}, '
              '${item['amount']}';
        }).toList();
        // Aquí asumo que los valores del mapa son cadenas
        dataList2 = responseData.map((value) => value.toString()).toList();

        print('Exito -> $baseUrl5/datosoPagos/$fac');
        return dataList;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/datosoPagos/$fac');
        return [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return [];
    }
  }

  Future<List<String>> dataTablePlazo(String id) async {
    List<String> dataList2;
    List<String> dataList3;
    double totalAcumulado = 0.0;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl5/datosoPlazoPago/$id'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<String> dataList = responseData.map((item) {
          return '${item['value']}, '
              '${item['days']}, '
              '${item['months']}, '
              '${item['discount_percentage']}, '
              '${item['value_amount']}';
        }).toList();

        dataList.sort((a, b) {
          List<String> splitA = a.split(',');
          List<String> splitB = b.split(',');
          int numA = int.parse(splitA[1]);
          int numB = int.parse(splitB[1]);
          return numA.compareTo(numB); // Ordena de menor a mayor
        });

        dataList = dataList.map((data) {
          List<String> splitData = data.split(',');
          List<String> modifiedValues = splitData.map((value) {
            if (value == 'balance') {
              return 'Saldo';
            } else if (value == 'percent') {
              return 'Porcentaje';
            } else {
              return value;
            }
          }).toList();

          return modifiedValues.join(',');
        }).toList();

        dataList.forEach((data) {
          print(data);
        });
        // Aquí asumo que los valores del mapa son cadenas
        dataList2 = responseData.map((value) => value.toString()).toList();

        print('Exito -> $baseUrl5/datosoPlazoPago/$id');
        return dataList;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl5/datosoPlazoPago/$id');
        return [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return [];
    }
  }

  Future<List<String>> dataTableFac() async {
    List<String> dataList2;
    List<String> dataList3;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl5/datosoFacturas'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        List<String> dataList = responseData
            .where((item) => item['type_name'] == 'Factura')
            .map((item) {
          // Convierte las fechas de tipo String a objetos DateTime
          DateTime invoiceDateDue = formatter.parse(item['invoice_date_due']);

          // Calcula la diferencia de días entre la fecha actual y invoice_date_due
          DateTime now = DateTime.now();
          int daysDifference = invoiceDateDue.difference(now).inDays;
          daysDifference = daysDifference < 0 ? 0 : daysDifference;
          String dueDate = daysDifference != 0
              ? 'En ' + daysDifference.toString() + ' dias'
              : 'Caducado';
          return '${item['id']}-- '
              '${item['name']}-- '
              '${item['invoice_partner_display_name']}-- '
              '${item['invoice_date']}-- '
              '${dueDate}-- '
              '${item['amount_total']}-- '
              '${item['payment_state']}-- '
              '${item['invoice_payment_term_id'] is List ? item['invoice_payment_term_id'][0] : 'N/A'}-- '
              '${item['amount_residual']}-- ';
        }).toList();
        dataList.sort((a, b) {
          String nameA = a.split('--')[1]; // Obtener el nombre de 'a'
          String nameB = b.split('--')[1]; // Obtener el nombre de 'b'

          // Comparar los nombres y devolver el resultado
          return nameA.compareTo(nameB);
        });
        dataList.map((data) {
          List<String> splitData = data.split('--');
          List<String> modifiedValues = splitData.map((value) {
            if (value.trim() == 'not_paid') {
              return 'No pagado';
            } else if (value.trim() == 'paid') {
              return 'Pagado';
            } else {
              return value;
            }
          }).toList();

          return modifiedValues.join('--');
        }).toList();
        // Aquí asumo que los valores del mapa son cadenas
        dataList2 = responseData.map((value) => value.toString()).toList();

        print('Exito -> $baseUrl5/datosoFacturas');
        return dataList;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/datosoFacturas');
        return [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return [];
    }
  }

  Future<List<String>> dataTableE(String fechaI, String fechaF) async {
    List<String> dataList2;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl2/$fechaI/$fechaF'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        List<String> dataList2 =
            stringList.map((element) => element.toString()).toList();
        print('Exito -> $baseUrl2/$fechaI/$fechaF');
        // String a = _dataList2.toString();
        // print('$_dataList2');
        return dataList2;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/$fechaI/$fechaF');
        return dataList2 = [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return dataList2 = [];
    }
  }

  Future<List<String>> dataTableET(
      String fechaI, String fechaF, String empCode) async {
    List<String> dataList2;
    String empCodee = empCode.replaceAll(RegExp(r'^0+'), '');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl2/$empCodee/$fechaI/$fechaF'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        List<String> dataList2 =
            stringList.map((element) => element.toString()).toList();
        print('Exito -> $baseUrl2/$empCodee/$fechaI/$fechaF');
        // String a = _dataList2.toString();
        // print('$_dataList2');
        return dataList2;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print('$baseUrl2/$empCodee/$fechaI/$fechaF');
        return dataList2 = [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return dataList2 = [];
    }
  }

  Future<List<String>> departamentos() async {
    List<String> dataList2;
    try {
      final response = await http.get(
        Uri.parse(baseUrl4),
      );

      if (response.statusCode == 200) {
        final List<dynamic> stringList = json.decode(response.body);
        List<String> dataList2 =
            stringList.map((element) => element.toString()).toList();
        print('Exito -> $baseUrl4');
        // String a = _dataList2.toString();
        // print('$_dataList2');
        return dataList2;
      } else {
        print('Error al obtener datos desde la API: ${response.statusCode}');
        print(baseUrl4);
        return dataList2 = [];
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return dataList2 = [];
    }
  }
}
