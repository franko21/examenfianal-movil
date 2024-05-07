import 'package:flutter/material.dart';
import 'package:flutter_application/Recuperar_contrase%C3%B1acomp/cambiocontra.dart';
import 'package:flutter_application/Recuperar_contrase%C3%B1acomp/correopage.dart';

class CambioContraseniaPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final emailService = EmailService();

  CambioContraseniaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Cambio de Contraseña'),
          ],
        ),
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
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese su correo electrónico',
                        labelText: 'Correo Electrónico',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _enviarCorreo(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => contrasena2()),
                        );
                      },
                      child: Text('Enviar'),
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

  void _enviarCorreo(BuildContext context) async {
    final String email = _emailController.text;
    try {
      final bool exists = await emailService.existeUsuario(email);
      print('casi: $exists');
      if (exists) {
        final response =
            await emailService.sendRecuperacionPasswordByEmail(email);
        print(response);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => contrasena2()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => contrasena2()),
        );
        // Muestra una notificación al usuario si el correo no existe
        _showErrorNotification(context, 'El correo electrónico no existe');
      }
    } catch (e) {
      print('Error: $e');
      // Agrega aquí la lógica para manejar errores
    }
  }

  void _showErrorNotification(BuildContext context, String message) {
    // Muestra una notificación de error al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
