import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';
import 'package:flutter_application/Recuperar_contrase%C3%B1acomp/correopage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambio de Contraseña',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: contrasena2(),
    );
  }
}

class contrasena2 extends StatefulWidget {
  @override
  _contrasena2State createState() => _contrasena2State();
}

class _contrasena2State extends State<contrasena2> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final CambiarContraseniaService emailService = CambiarContraseniaService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showToken = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambio de Contraseña'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    TextField(
                      controller: _tokenController,
                      obscureText: !_showToken,
                      decoration: InputDecoration(
                        hintText: 'Ingrese el codigo de Verificacion',
                        labelText: 'codigo',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showToken
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showToken = !_showToken;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Ingrese la nueva contraseña',
                        labelText: 'Nueva Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _togglePasswordVisibility();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirme la nueva contraseña',
                        labelText: 'Confirmar Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _toggleConfirmPasswordVisibility();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _cambiarContrasenia(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Cambiar Contraseña'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cambiarContrasenia(BuildContext context) async {
    final token = _tokenController.text;
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      // Si las contraseñas no coinciden, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Las contraseñas no coinciden'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      final message = await emailService.cambiarContraseniaUsuario({
        'token': token,
        'password': newPassword,
        'passwordr': confirmPassword, // Agrega la confirmación de la contraseña
      });
      print(message);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }
}
