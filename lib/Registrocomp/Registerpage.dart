import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'ApiClient.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mi Aplicación',
      home: Registerpage(),
    );
  }
}

void _showErrorNotification(BuildContext context, String message) {
  // Implementa la lógica para mostrar una notificación al usuario
  // Puedes usar paquetes como `fluttertoast` o `snackbar` para mostrar la notificación
  // Aquí un ejemplo con `fluttertoast`:

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 10,
    backgroundColor: Colors.yellow,
    textColor: Colors.black,
  );
}

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<Registerpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  final TextEditingController _idDepartamentoController =
      TextEditingController();
  final ApiClient _apiClient = ApiClient();
  String _selectedValueRol = 'ADMIN';
  String _selectedValueDepa = 'Departmentos';
  List<String> depas = ['Departmentos', 'Otros'];

  void _depas() async {
    final List<String> depasexits = await _apiClient.departamentos();

    setState(() {
      depas = depasexits;
      _selectedValueDepa = depas[0];
    });
    print('$depas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onTap: () {
                _depas();
              },
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _dniController,
              decoration: const InputDecoration(labelText: 'DNI'),
            ),
            const SizedBox(height: 20),
            Text(
              'Rol',
              textAlign: TextAlign.left,
            ),
            DropdownButton<String>(
              value: _selectedValueRol,
              onChanged: (newValue) {
                setState(() {
                  _selectedValueRol = newValue!;
                });
              },
              items: <String>['ADMIN', 'USER']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text(
              'Departamentos',
              textAlign: TextAlign.left,
            ),
            DropdownButton<String>(
              value: _selectedValueDepa,
              onChanged: (newValue) {
                setState(() {
                  _selectedValueDepa = newValue!;
                });
              },
              items: depas.map<DropdownMenuItem<String>>((String value2) {
                return DropdownMenuItem<String>(
                  value: value2,
                  child: Text(value2),
                );
              }).toList(),
            ),
            // TextFormField(
            //   controller: _rolController,
            //   decoration: const InputDecoration(labelText: 'Rol'),
            // ),
            // const SizedBox(height: 20),
            // TextFormField(
            //   controller: _idDepartamentoController,
            //   decoration: const InputDecoration(labelText: 'ID Departamento'),
            // ),
            // const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  // final String empleadoExists = await _apiClient
                  //     .existeEmpleado(_dniController.text.toString() ?? '');

                  _register

              // else if (empleadoExists.length == 0) {
              //   Future.delayed(const Duration(seconds: 2), () {
              //     // Mostrar notificación de error al usuario
              //     _showErrorNotification(context, 'El empleado no existe');
              //   });
              // } else if (empleadoExists.length != 0) {
              //   print(empleadoExists);

              //}
              ,
              child: const Text('Registrarse'),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> _register() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String nombre = _nombreController.text;
    final String apellido = _apellidoController.text;
    final String dni = _dniController.text;
    final String rol = _selectedValueRol.toString(); // _rolController.text;
    final String idDepartamento = _selectedValueDepa
        .toString()
        .split(' ')[0]; //_idDepartamentoController.text;

    if (_emailController.text.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'Debe de ingresar el email');
      });
      return;
    } else if (_passwordController.text.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'Debe de ingresar la contrasenia');
      });
      return;
    } else if (_nombreController.text.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'Debe de ingresar sus nombres');
      });
      return;
    } else if (_apellidoController.text.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'Debe de ingresar sus apellidos');
      });
      return;
    } else if (_dniController.text.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'Debe de ingresar su cedula');
      });
      return;
    } else if (rol.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'Debe de ingresar su rol');
      });
      return;
    } else if (idDepartamento.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(
            context, 'Debe de ingresar a que departamento pertenece');
      });
      return;
    }

    try {
      // Envía los datos al servidor utilizando un formato adecuado
      final String exists = await _apiClient
          .existeEmpleado(_dniController.text.replaceAll(RegExp(r'^0+'), ''));
      if (exists.length == 0) {
        Future.delayed(const Duration(seconds: 2), () {
          // Mostrar notificación de error al usuario
          _showErrorNotification(context, 'No existe ese empleado con ese dni');
        });
        return;
      } else {
        try {
          // Envía los datos al servidor utilizando un formato adecuado
          String dnii = dni.replaceAll(RegExp(r'^0+'), '');
          final bool register = await _apiClient.registerUser(email, password,
              nombre, apellido, dnii, _selectedValueRol, idDepartamento);
          if (register) {
            Future.delayed(const Duration(seconds: 2), () {
              // Mostrar notificación de error al usuario
              _showErrorNotification(context, 'Empleado registrado con exito');
            });
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
          } else {
            Future.delayed(const Duration(seconds: 2), () {
              // Mostrar notificación de error al usuario
              _showErrorNotification(
                  context, 'Email en uso, o empleado ya registrado');
            });
          }
          // Si el registro es exitoso, puedes navegar a otra pantalla
          // Navigator.push(context, MaterialPageRoute(builder: (context) => OtraPantalla()));
        } catch (e) {
          // Maneja los errores aquí
          print('Error al registrar al usuario: $e');
          // Muestra un diálogo de error o realiza alguna otra acción apropiada
        }
      }
      // Si el registro es exitoso, puedes navegar a otra pantalla
      // Navigator.push(context, MaterialPageRoute(builder: (context) => OtraPantalla()));
    } catch (e) {
      // Maneja los errores aquí
      print('Error al buscar empleado: $e');
      // Muestra un diálogo de error o realiza alguna otra acción apropiada
    }

    // Realiza el registro del usuario
  }
}

void main() {
  runApp(MyApp());
}
