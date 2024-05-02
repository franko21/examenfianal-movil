import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application/Notificacionescomp/notificaciones.dart';
import 'package:flutter_application/Recuperar_contrase%C3%B1acomp/verificaioncorreo.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';
import 'package:flutter_application/Registrocomp/Registerpage.dart';
import 'package:flutter_application/TablaIngresocomp/MyAdminWelcome.dart';
import 'package:flutter_application/TablaIngresocomp/MyhomePageState.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350, // Ajusta el ancho del contenedor
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(159, 164, 215, 229).withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LoginForm(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Espacio entre el contenedor y los botones
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
  bool _isButtonPressed = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Usuario'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Contraseña'),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isButtonPressed = true;
                  });
                  _login(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (_isButtonPressed) {
                      return Colors.blue;
                    }
                    return const Color.fromARGB(255, 241, 248, 242);
                  }),
                  // Aumenta el tamaño del botón
                  minimumSize: MaterialStateProperty.all<Size>(Size(150, 50)),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Ingresar'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Instancia de la pantalla de registro desde otra clase
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registerpage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return Color.fromARGB(255, 246, 246,
                        246); // Mismo estilo que el botón de ingresar
                  }),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(100, 50)), // Mismo tamaño que el botón de ingresar
                ),
                child: Text('Registrarse'),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CambioContraseniaPage()),
            );
          },
          child: Text('Recuperar contraseña'),
        ),
      ],
    );
  }

  void _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    String role = '';

    setState(() {
      _isLoading = true;
    });

    try {
      final String loginSuccessful =
          await _apiClient.signinUser(username, password, role);
      if (loginSuccessful.isNotEmpty) {
        if (loginSuccessful.toString().split(' ')[0] == 'ADMIN') {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isLoading = false;
            });
            // Placeholder for login logic
            print('Login successful');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WelcomeAdminScreen(),
              ),
            );
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            // Placeholder for login logic
            print('Login successful, Empleado $loginSuccessful.toString()');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
            setState(() {
              _isLoading = false;
            });
          });
        }
      } else {
        // El inicio de sesión falló
        print('Inicio de sesión fallido');

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isLoading = false;
          });
          // Mostrar notificación de error al usuario
          showErrorNotification(
              context,
              'Inicio de sesión fallido, Revisa el usuario y la contrasenia',
              0);
        });
      }
    } catch (e) {
      // Manejo de errores (por ejemplo, problemas de red, errores del servidor, etc.)
      print('Error durante el inicio de sesión: $e');
      setState(() {
        _isLoading = false;
      });
      showErrorNotification(context, 'Error: $e', 0);
    }
  }
}
