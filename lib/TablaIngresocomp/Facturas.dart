import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';
import 'package:flutter_application/Notificacionescomp/notificaciones.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';
import 'package:flutter_application/TablaIngresocomp/MyhomePageState.dart';
import 'package:intl/intl.dart';

// Variables globales
String nombreU = '';
String dniU = '';
List<String> _dataListU = [];
List<String> _dataListP = [];
List<String> _dataListC = [];
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

  void _dataTableOn() async {
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

  @override
  void initState() {
    super.initState();
    _dataTableOn();
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
            ElevatedButton(
              onPressed: () {
                _dataTableOn();
              },
              child: Text('Buscar'),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    // DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Numero')),
                    DataColumn(label: Text('Cliente')),
                    DataColumn(label: Text('Fecha Creada')),
                    DataColumn(label: Text('Fecha Vencimiento')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Estado')),
                    // DataColumn(label: Text('Plazo')),
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
                      cells: [
                        DataCell(Text(splitData[1])), // Dias
                        DataCell(Text(splitData[2])),
                        DataCell(Text(splitData[3])),
                        DataCell(Text(splitData[4])),
                        DataCell(Text(splitData[5])),
                        DataCell(Text(splitData[6])), // A pagar
                      ],
                      onSelectChanged: (bool? selected) {
                        setState(() {
                          _selectedRowIndex = index;
                        });
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  data: splitData,
                                  plazo: splitData[7],
                                  numero: splitData[1],
                                  total: splitData[5]),
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

class DetailPage extends StatefulWidget {
  final String plazo;
  final String numero;
  final String total;
  final List<String> data;

  DetailPage(
      {required this.data,
      required this.plazo,
      required this.numero,
      required this.total});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  void _dataTableOnP() async {
    final List<String> _dataListE =
        await _apiClient.dataTablePagos(widget.numero.trim());
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListP = _dataListE;
    });

    if (_dataListP.length == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        showErrorNotification(context, 'No se encontraron datos', 1);
      });
    }
    // String d = _dataListU;
    print('$_dataListP');
    // print('$d');
  }

  void _dataTableOnC() async {
    final List<String> _dataListE =
        await _apiClient.dataTablePlazo(widget.plazo.trim());
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListC = _dataListE;
    });
    double totalAcumulado = 0.0;
    if (_dataListC.length == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        showErrorNotification(context, 'No se encontraron datos', 1);
      });
    } else {
      List<String> sortedList =
          List.from(_dataListC); // Copiamos la lista original para ordenarla
      sortedList.sort((a, b) {
        List<String> splitA = a.split(',');
        List<String> splitB = b.split(',');
        int numA = int.parse(splitA[1]);
        int numB = int.parse(splitB[1]);
        return numA.compareTo(numB); // Ordena de menor a mayor
      });
      sortedList = sortedList.map((data) {
        NumberFormat formatter = NumberFormat("#.##");
        List<String> splitData = data.split(',');
        if (splitData[0] == 'balance') {
          double totalAnterior = double.parse(widget.total) - totalAcumulado;
          String tot = formatter.format(totalAnterior);
          splitData.add(tot);
        } else {
          double resultado =
              double.parse(widget.total) * (double.parse(splitData[4]) / 100);
          totalAcumulado += resultado;
          String res = formatter.format(resultado);
          splitData.add(res);
        }
        // Realizar la multiplicación y convertir a String

        return splitData.join(',');
      }).toList();
      sortedList = sortedList.map((data) {
        List<String> splitData = data.split(',');
        List<String> modifiedValues = splitData.map((value) {
          if (value == 'balance') {
            return 'Saldo';
          } else if (value == 'percent') {
            return 'Porcentaje';
          } else {
            return value;
          }
        }).toList();

        return modifiedValues.join(',');
      }).toList();

      sortedList.forEach((data) {
        print(data);
      });
      setState(() {
        // Actualiza _dataListU con los nuevos datos
        _dataListC = sortedList;
      });
    }
    // String d = _dataListU;
    print('$_dataListC');
    // print('$d');
  }

  @override
  void initState() {
    super.initState();
    _dataTableOnP();
    _dataTableOnC();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Factura'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widget.data
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 18, // Tamaño de la fuente
                          fontWeight: FontWeight.normal, // Peso de la fuente
                          color: Colors.black87, // Color de la fuente
                        ),
                      ),
                    ))
                .toList(),
            // ...widget.data.map((item) => Text(item)).toList(),
            Text('\n\nPagos: ${widget.numero}'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Referencia')),
                  DataColumn(label: Text('Partner')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Total')),
                ],
                rows: _dataListP.map((data) {
                  List<String> splitData = data.split(',');
                  if (splitData.length == 5) {
                    return DataRow(
                      cells: [
                        DataCell(Text(splitData[1])), // Dias
                        DataCell(Text(splitData[2])),
                        DataCell(Text(splitData[3])),
                        DataCell(Text(splitData[4])), // A pagar
                      ],
                    );
                  } else {
                    // Retorna una fila vacía o maneja el error de acuerdo a tus necesidades
                    return DataRow(
                      cells: List<DataCell>.generate(
                          7, (index) => DataCell(Text(''))),
                    );
                  }
                  ;
                }).toList(),
              ),
            ),
            Text('\n\nCuotas: ${widget.numero}'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Tipo')),
                  DataColumn(label: Text('Dias')),
                  DataColumn(label: Text('Meses')),
                  DataColumn(label: Text('Porcentaje')),
                  DataColumn(label: Text('A pagar')),
                ],
                rows: _dataListC.map((data) {
                  List<String> splitData = data.split(',');
                  if (splitData.length == 6) {
                    return DataRow(
                      cells: [
                        DataCell(Text(splitData[0])),
                        DataCell(Text(splitData[1])), // Dias
                        DataCell(Text(splitData[2])),
                        DataCell(Text(splitData[4] + '%')),
                        DataCell(Text(splitData[5])), // A pagar
                      ],
                    );
                  } else {
                    // Retorna una fila vacía o maneja el error de acuerdo a tus necesidades
                    return DataRow(
                      cells: List<DataCell>.generate(
                          7, (index) => DataCell(Text(''))),
                    );
                  }
                  ;
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
