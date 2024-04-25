import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';
import 'package:flutter_application/Notificacionescomp/notificaciones.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';
import 'package:flutter_application/main.dart';

// Variables globales
String nombreU = '';
String dniU = '';
List<String> _dataListU = [];
final ApiClient _apiClient = ApiClient();

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Fondo azul
        title: Text('Bienvenido $nombreU'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _dataListU = [];
              dniU = '';

              Future.delayed(const Duration(seconds: 2), () {
                try {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                } catch (e) {
                  print('$e');
                }
              });
              print('Cerrando sesión...');
            },
          ),
        ],
      ),
      body: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _selectedDate;
  DateTime? _selectedDate2;

  void _dataTableOn(DateTime? selectedDate, DateTime? selectedDate2) async {
    final List<String> dataListE = await _apiClient.dataTableET(
      '${selectedDate.toString().split(' ')[0]}T00:00:00',
      '${selectedDate2.toString().split(' ')[0]}T23:59:59',
      dniU,
    );

    setState(() {
      _dataListU = dataListE;
    });

    if (_dataListU.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        showErrorNotification(context, 'No se encontraron datos', 1);
      });
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _presentDatePicker2() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate2) {
      if (pickedDate2 == null) {
        return;
      }
      setState(() {
        _selectedDate2 = pickedDate2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcaciones Empleado'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Fecha Inicio'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _presentDatePicker2,
                  child: const Text('Fecha Fin'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDate == null) {
                      Future.delayed(const Duration(seconds: 2), () {
                        showErrorNotification(
                            context, 'Debe seleccionar la fecha de inicio', 0);
                      });
                    } else if (_selectedDate2 == null) {
                      Future.delayed(const Duration(seconds: 2), () {
                        showErrorNotification(
                            context, 'Debe seleccionar la fecha fin', 0);
                      });
                    } else if (_selectedDate2!.isBefore(_selectedDate!)) {
                      Future.delayed(const Duration(seconds: 2), () {
                        showErrorNotification(
                            context,
                            'La fecha de inicio debe ser igual o anterior a la fecha fin',
                            0);
                      });
                    } else {
                      _dataTableOn(_selectedDate, _selectedDate2);
                      print('Búsqueda realizada para fecha $_selectedDate');
                    }
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _selectedDate != null
                    ? 'Inicio: ${_selectedDate.toString().split(' ')[0]} - Fin: ${_selectedDate2.toString().split(' ')[0]}'
                    : 'Ninguna fecha seleccionada',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Cedula')),
                  DataColumn(label: Text('Colaborador')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Hora')),
                  DataColumn(label: Text('Tipo')),
                  DataColumn(label: Text('VerifyCode')),
                  DataColumn(label: Text('SensorId')),
                  DataColumn(label: Text('Aprobacion')),
                ],
                dataRowHeight: 40, // Reducir el tamaño de la fila de la tabla
                rows: _dataListU.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.split(',')[2])),
                    DataCell(Text(data.split(',')[3])),
                    DataCell(Text(data.split(',')[4].split(' ')[0])),
                    DataCell(Text(data.split(',')[4].split(' ')[1])),
                    DataCell(Text(data.split(',')[5] ?? '')),
                    DataCell(Text(data.split(',')[6])),
                    DataCell(Text(data.split(',')[7])),
                    DataCell(Text(data.split(',')[8])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getDayOfWeek(String dateString) {
  final DateTime? parsedDate = DateTime.tryParse(dateString);

  if (parsedDate == null) {
    return 'Fecha inválida';
  }

  final int dayOfWeek = parsedDate.weekday;

  switch (dayOfWeek) {
    case 1:
      return 'Lunes';
    case 2:
      return 'Martes';
    case 3:
      return 'Miércoles';
    case 4:
      return 'Jueves';
    case 5:
      return 'Viernes';
    case 6:
      return 'Sábado';
    case 7:
      return 'Domingo';
    default:
      return 'Día desconocido';
  }
}
