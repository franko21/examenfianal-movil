import 'package:flutter/material.dart';
import 'ApiClient.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mi Aplicación',
      home: Registerpage(),
    );
  }
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

  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Envuelve el widget Registerpage con Scaffold
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
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
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String nombre = _nombreController.text;
    final String apellido = _apellidoController.text;
    final String dni = _dniController.text;

    // Realiza el registro del usuario
    try {
      await _apiClient.registerUser(email, password, nombre, apellido, dni);
      // Si el registro es exitoso, puedes navegar a otra pantalla
      // Navigator.push(context, MaterialPageRoute(builder: (context) => OtraPantalla()));
    } catch (e) {
      // Maneja los errores aquí
      print('Error al registrar al usuario: $e');
      // Muestra un diálogo de error o realiza alguna otra acción apropiada
    }
  }
}

void main() {
  runApp(MyApp());
}
