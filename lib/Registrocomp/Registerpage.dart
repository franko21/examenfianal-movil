import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';
import 'package:flutter_application/main.dart';
import 'ApiClient.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  // Puedes usar paquetes como fluttertoast o snackbar para mostrar la notificación
  // Aquí un ejemplo con fluttertoast:

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
  const Registerpage({super.key});

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
  String _selectedValueDepa = 'Seleccionar';
  List<String> depas = ['Seleccionar', 'Departmentos', 'Otros'];

  void _depas() async {
    final List<String>? depasexits = await _apiClient.departamentos();

    if (depasexits != null && depasexits.isNotEmpty) {
      setState(() {
        depas = depasexits;
        _selectedValueDepa = depas[0];
      });
      print('$depas');
    } else {
      // Maneja el caso en que la lista de departamentos esté vacía o nula
      print('La lista de departamentos está vacía o nula');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Registro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                onTap: _depas,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nombreController,
                labelText: 'Nombre',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _apellidoController,
                labelText: 'Apellido',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _dniController,
                labelText: 'DNI',
              ),
              const SizedBox(height: 20),
              Text(
                'Departamento',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Tamaño de fuente deseado
                ),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrarse'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // foreground
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _register() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String nombre = _nombreController.text;
    final String apellido = _apellidoController.text;
    final String dni = _dniController.text;
    final String rol = 'ADMIN'; // _rolController.text;
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
      if (exists.isEmpty) {
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
  runApp(const MyApp());
}
