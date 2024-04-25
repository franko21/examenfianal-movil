import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showErrorNotification(BuildContext context, String message, int c) {
  // Implementa la lógica para mostrar una notificación al usuario
  // Puedes usar paquetes como `fluttertoast` o `snackbar` para mostrar la notificación
  // Aquí un ejemplo con `fluttertoast`:

  switch (c) {
    case 0:
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      break;
    case 1:
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
      );
      break;
  }
}
