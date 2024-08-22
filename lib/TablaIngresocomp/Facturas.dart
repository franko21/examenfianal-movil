import 'package:flutter/material.dart';
import 'dart:async';
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
  late Completer<void> _completer3;
  int _selectedRowIndex = 0;
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  String searchText = '';

  Future<void> _dataTableOn() async {
    final List<String> _dataListE = await _apiClient.dataTableFac();

    if (!mounted) return;
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListU = _dataListE;
    });

    if (_dataListU.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        // Mostrar notificación de error al usuario
        showErrorNotification(context, 'No se encontraron facturas', 1);
      });
    } else {
      List<String> sortedList = List.from(_dataListU);
      sortedList = sortedList.map((data) {
        List<String> splitData = data.split('--');
        List<String> modifiedValues = splitData.map((value) {
          if (value.trim() == 'not_paid') {
            return 'No pagado';
          } else if (value.trim() == 'paid') {
            return 'Pagado';
          } else if (value.trim() == 'partial') {
            return 'Parcialmente Pagado';
          } else {
            return value;
          }
        }).toList();

        return modifiedValues.join('--');
      }).toList();

      if (!mounted) return;
      setState(() {
        // Actualiza _dataListU con los nuevos datos
        _dataListU = sortedList;
      });
    }
    print('$_dataListU');
  }

  @override
  void initState() {
    super.initState();
    _dataTableOn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null || !mounted) return;
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
      if (pickedDate2 == null || !mounted) return;
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
              onPressed: _dataTableOn,
              child: Text('Buscar'),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text('Numero',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Cliente',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Fecha Creada',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Vencimiento',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Total',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Estado',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
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
                          return Colors.transparent;
                        },
                      ),
                      cells: [
                        DataCell(Text(splitData[1],
                            style: TextStyle(fontSize: 16.0))),
                        DataCell(Text(splitData[2],
                            style: TextStyle(fontSize: 16.0))),
                        DataCell(Text(splitData[3],
                            style: TextStyle(fontSize: 16.0))),
                        DataCell(Text(splitData[4],
                            style: TextStyle(fontSize: 16.0))),
                        DataCell(Text("\$" + splitData[5],
                            style: TextStyle(fontSize: 16.0))),
                        DataCell(
                          Container(
                            color: splitData[6] == 'No pagado'
                                ? Colors.red.withOpacity(0.3)
                                : splitData[6] == 'Parcialmente Pagado'
                                    ? Colors.yellow
                                    : Colors.green.withOpacity(0.3),
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              splitData[6],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                      onSelectChanged: (bool? selected) {
                        if (!mounted) return;
                        setState(() {
                          _selectedRowIndex = index;
                        });
                        Future.delayed(Duration(milliseconds: 300), () {
                          if (!mounted) return;
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
  late Completer<void> _completerP;
  late Completer<void> _completerC;

  @override
  void dispose() {
    if (!_completerP.isCompleted) _completerP.complete();
    if (!_completerC.isCompleted) _completerC.complete();
    super.dispose();
  }

  Future<void> _dataTableOnP() async {
    final List<String> _dataListE =
        await _apiClient.dataTablePagos(widget.numero.trim());

    if (!mounted) return;
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListP = _dataListE;
    });

    if (_dataListP.length == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        if (!mounted) return;
        showErrorNotification(context, 'No se encontraron pagos', 1);
      });
    }
    // String d = _dataListU;
    print('$_dataListP');
    // print('$d');
    // _completer.complete();
  }

  Future<void> _dataTableOnC() async {
    final List<String> _dataListE =
        await _apiClient.dataTablePlazo(widget.plazo.trim());
    if (!mounted) return;
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListC = _dataListE;
    });

    double totalAcumulado = 0.0;
    if (_dataListC.length == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        if (!mounted) return;
        showErrorNotification(context, 'No se encontraron cuotas', 1);
      });
    } else {
      List<String> sortedList =
          List.from(_dataListC); // Copiamos la lista original para ordenarla
      sortedList = sortedList.map((data) {
        NumberFormat formatter = NumberFormat("#.##");
        List<String> splitData = data.split(',');
        if (splitData[0] == 'Saldo') {
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

      sortedList.forEach((data) {
        print(data);
      });
      if (!mounted) return;
      setState(() {
        // Actualiza _dataListU con los nuevos datos
        _dataListC = sortedList;
      });
    }
    // String d = _dataListU;
    print('$_dataListC');
    // print('$d');
    // _completer2.complete();
  }

  @override
  void initState() {
    super.initState();
    _completerP = Completer<void>();
    _completerC = Completer<void>();
    _dataTableOnP().then((_) => _completerP.complete());
    _dataTableOnC().then((_) => _completerC.complete());
  }

  @override
  Widget build(BuildContext context) {
    String saldo = widget.data.length > 8 ? widget.data[8] : '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Factura'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widget.data
                .asMap()
                .entries
                .where((entry) => [1, 2, 3, 4, 5, 6].contains(entry.key))
                .map((entry) {
              int index = entry.key;
              String item = entry.value;

              String title = "";
              if (index == 1) {
                title = "Factura:";
              } else if (index == 2) {
                title = "Cliente:";
              } else if (index == 3) {
                title = "Fecha Creada:";
              } else if (index == 4) {
                title = "Fecha Vencimiento:";
              } else if (index == 5) {
                title = "Total:";
              } else if (index == 6) {
                title = "Estado :";
              }

              if (index == 6) {
                Color backgroundColor = item == 'No pagado'
                    ? Colors.red.withOpacity(0.3)
                    : item == 'Parcialmente Pagado'
                        ? Colors.yellow
                        : Colors.green.withOpacity(0.3);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
            // ...widget.data.map((item) => Text(item)).toList(),
            Text('\n\nPagos',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text('Referencia',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('Cliente',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('Fecha',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('Total',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                ],
                rows: _dataListP.map((data) {
                  List<String> splitData = data.split(',');
                  if (splitData.length == 5) {
                    return DataRow(
                      cells: [
                        DataCell(Text(splitData[1],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500))), // Dias
                        DataCell(Text(splitData[2],
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500))),
                        DataCell(Text(splitData[3],
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500))),
                        DataCell(Text(splitData[4],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900))), // A pagar
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
            Text('\n\nCuotas',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text('Tipo',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('Dias',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('Meses',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('Porcentaje',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                  DataColumn(
                      label: Text('A pagar',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w700))),
                ],
                rows: _dataListC.map((data) {
                  List<String> splitData = data.split(',');
                  if (splitData.length == 6) {
                    return DataRow(
                      cells: [
                        DataCell(Text(splitData[0],
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w700))),
                        DataCell(Text(splitData[1],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500))), // Dias
                        DataCell(Text(splitData[2],
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500))),
                        DataCell(Text(splitData[4] + '%',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500))),
                        DataCell(Text(splitData[5],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900))), // A pagar
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
            Text(
              '\n\nImporte adeudado: \n\$\ ${saldo} \n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Color azul para resaltar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
