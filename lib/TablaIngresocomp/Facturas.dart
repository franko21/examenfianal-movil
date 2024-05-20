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

class FacturaScreen extends StatelessWidget {
  const FacturaScreen({super.key});

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
      body: FacturaPage(),
    );
  }
}

class FacturaPage extends StatefulWidget {
  @override
  _FacturaState createState() => _FacturaState();
}

class _FacturaState extends State<FacturaPage> {
  int _selectedRowIndex = 0;
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  String searchText = '';

  void _dataTableOn(DateTime? _selectedDate, DateTime? _selectedDate2) async {
    final List<String> _dataListE = await _apiClient.dataTableFac();
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
    // String d = _dataListU;
    print('$_dataListU');
    // print('$d');
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
          title: Text('Facturas'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
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
                // if (searchText.isEmpty) {
                //   Future.delayed(const Duration(seconds: 2), () {
                //     // Mostrar notificación de error al usuario
                //     showErrorNotification(
                //         context, 'Debe de ingresar la cedula del usuario', 0);
                //   });
                // } else if (_selectedDate == null) {
                //   Future.delayed(const Duration(seconds: 2), () {
                //     // Mostrar notificación de error al usuario
                //     showErrorNotification(
                //         context, 'Debe de seleccionar la fecha de inicio', 0);
                //   });
                // } else if (_selectedDate2 == null) {
                //   Future.delayed(const Duration(seconds: 2), () {
                //     // Mostrar notificación de error al usuario
                //     showErrorNotification(
                //         context, 'Debe de seleccionar la fecha fin', 0);
                //   });
                // } else if (_selectedDate2?.isBefore(_selectedDate!) ?? false) {
                //   Future.delayed(const Duration(seconds: 2), () {
                //     // Mostrar notificación de error al usuario
                //     showErrorNotification(
                //         context,
                //         'La fecha de inicio debe ser igual o anterior a la fecha fin',
                //         0);
                //   });
                // } else {
                _dataTableOn(_selectedDate, _selectedDate2);
                print('Búsqueda realizada para fecha $_selectedDate');
                //}
              },
              child: Text('Buscar'),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Numero')),
                    DataColumn(label: Text('Cliente')),
                    DataColumn(label: Text('Fecha Creada')),
                    DataColumn(label: Text('Fecha Vencimiento')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Estado')),
                    DataColumn(label: Text('Plazo')),
                  ],
                  rows: _dataListU.asMap().entries.map((entry) {
                    int index = entry.key;
                    String data = entry.value;
                    List<String> splitData = data.split('--');

                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (_selectedRowIndex == index) {
                            return Colors.blue.withOpacity(0.5);
                          }
                          return Colors.transparent; // Use the default value.
                        },
                      ),
                      cells: splitData
                          .map((cell) => DataCell(Text(cell)))
                          .toList(),
                      onSelectChanged: (bool? selected) {
                        setState(() {
                          _selectedRowIndex = index;
                        });
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(data: splitData),
                            ),
                          );
                        });
                      },
                    );
                  }).toList(),
                ))
          ]),
        ));
  }
}

class DetailPage extends StatelessWidget {
  final List<String> data;

  DetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: data.map((item) => Text(item)).toList(),
        ),
      ),
    );
  }
}
