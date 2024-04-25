import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';
import 'package:flutter_application/Notificacionescomp/notificaciones.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';
import 'package:flutter_application/TablaIngresocomp/MyhomePageState.dart';

// Variables globales
String nombreU = '';
String dniU = '';
List<String> _dataListU = [];
final ApiClient _apiClient = ApiClient();

class WelcomeAdminScreen extends StatelessWidget {
  const WelcomeAdminScreen({super.key});

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
      body: MyHomeAdminPage(),
    );
  }
}

class MyHomeAdminPage extends StatefulWidget {
  @override
  _MyHomeAdminPageState createState() => _MyHomeAdminPageState();
}

class _MyHomeAdminPageState extends State<MyHomeAdminPage> {
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  String searchText = '';

  void _dataTableOn(DateTime? _selectedDate, DateTime? _selectedDate2) async {
    final List<String> _dataListE = await _apiClient.dataTableET(
      '${_selectedDate.toString().split(' ')[0]}T00:00:00',
      '${_selectedDate2.toString().split(' ')[0]}T23:59:59',
      searchText,
    );
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListU = _dataListE;
    });

    if (_dataListU.length == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        showErrorNotification(context, 'No se encontraron datos', 1);
      });
    }

    print('$_dataListU');
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
        title: Text('Marcaciones Talento Humano'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cedula empleado...',
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _presentDatePicker,
                child: Text('Fecha Inicio'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _presentDatePicker2,
                child: Text('Fecha Fin'),
              ),
              SizedBox(width: 16),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              _selectedDate != null
                  ? 'Inicio: ${_selectedDate.toString().split(' ')[0]}- Fin:${_selectedDate2.toString().split(' ')[0]}'
                  : 'Ninguna fecha seleccionada',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para realizar la búsqueda
              if (searchText.isEmpty) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  showErrorNotification(
                      context, 'Debe de ingresar la cedula del usuario', 0);
                });
              } else if (_selectedDate == null) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  showErrorNotification(
                      context, 'Debe de seleccionar la fecha de inicio', 0);
                });
              } else if (_selectedDate2 == null) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  showErrorNotification(
                      context, 'Debe de seleccionar la fecha fin', 0);
                });
              } else if (_selectedDate2?.isBefore(_selectedDate!) ?? false) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
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
            child: Text('Buscar'),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Cedula')),
                  DataColumn(label: Text('Colaborador')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Hora')),
                  DataColumn(label: Text('Tipo')),
                  DataColumn(label: Text('VerifyCode')),
                  DataColumn(label: Text('SensorId')),
                  DataColumn(label: Text('Aprobacion')),
                ],
                rows: _dataListU.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.split(',')[2])),
                    DataCell(Text(data.split(',')[3])),
                    DataCell(Text(data.split(',')[4].split(' ')[0])),
                    DataCell(Text(data.split(',')[4].split(' ')[1])),
                    DataCell(Text(
                        data.split(',')[5] != null ? data.split(',')[5] : '')),
                    DataCell(Text(data.split(',')[6])),
                    DataCell(Text(data.split(',')[7])),
                    DataCell(Text(data.split(',')[8])),
                    // DataCell(Text(getDayOfWeek(data.split(',')[6] + '.000'))),
                  ]);
                }).toList(),
              )),
        ],
      )),
    );
  }
}
