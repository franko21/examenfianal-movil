import 'package:flutter/material.dart';
import 'package:flutter_application/Recuperar_contrase%C3%B1acomp/cambiocontra.dart';
import 'package:flutter_application/Recuperar_contrase%C3%B1acomp/correopage.dart';

class CambioContraseniaPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final emailService = EmailService();

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
    try {
      final response =
          await emailService.sendRecuperacionPassword(_emailController.text);
      print(response);
      // Agrega aquí la lógica para mostrar el mensaje de éxito o manejar errores
    } catch (e) {
      print('Error: $e');
      // Agrega aquí la lógica para manejar errores
    }
  }
}
