// import 'package:flutter/material.dart';
// import 'package:flutter_application/Logincomp/Login.dart';
// import 'package:flutter_application/Notificacionescomp/notificaciones.dart';
// import 'package:flutter_application/Registrocomp/ApiClient.dart';
// import 'package:flutter_application/TablaIngresocomp/MyhomePageState.dart';

// // Variables globales
// String nombreU = '';
// String dniU = '';
// List<String> _dataListU = [];
// final ApiClient _apiClient = ApiClient();

// class WelcomeAdminScreen extends StatelessWidget {
//   const WelcomeAdminScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue, // Fondo azul
//         title: Text('Bienvenido'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () {
//               _dataListU = [];
//               dniU = '';

//               Future.delayed(const Duration(seconds: 2), () {
//                 try {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const LoginPage(),
//                     ),
//                   );
//                 } catch (e) {
//                   print('$e');
//                 }
//               });
//               print('Cerrando sesión...');
//             },
//           ),
//         ],
//       ),
//       body: MyHomeAdminPage(),
//     );
//   }
// }

// class MyHomeAdminPage extends StatefulWidget {
//   @override
//   _MyHomeAdminPageState createState() => _MyHomeAdminPageState();
// }

// class _MyHomeAdminPageState extends State<MyHomeAdminPage> {
//   DateTime? _selectedDate;
//   DateTime? _selectedDate2;
//   String searchText = '';

//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = DateTime.now(); // Establecer una fecha predeterminada
//     _selectedDate2 = DateTime.now(); // Establecer otra fecha predeterminada

//     // Llamar a _dataTableOn con las fechas seleccionadas al inicializar la pantalla
//     _dataTableOn(_selectedDate, _selectedDate2);
//   }

//   void _dataTableOn(DateTime? _selectedDate, DateTime? _selectedDate2) async {
//     final List<String> _dataListE = await _apiClient.dataTablePersonas();
//     setState(() {
//       // Actualiza _dataListU con los nuevos datos
//       _dataListU = _dataListE;
//     });

//     if (_dataListU.length == 0) {
//       Future.delayed(const Duration(seconds: 2), () {
//         // Mostrar notificación de error al usuario
//         showErrorNotification(context, 'No se encontraron datos', 1);
//       });
//     }

//     print('$_dataListU');
//   }

//   void _presentDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     ).then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     });
//   }

//   void _presentDatePicker2() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     ).then((pickedDate2) {
//       if (pickedDate2 == null) {
//         return;
//       }
//       setState(() {
//         _selectedDate2 = pickedDate2;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lista Personas'),
//       ),
//       body: SingleChildScrollView(
//           child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       searchText = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Cedula persona...',
//                   ),
//                 ),
//               ),
//               // SizedBox(width: 16),
//               // ElevatedButton(
//               //   onPressed: _presentDatePicker,
//               //   child: Text('Fecha Inicio'),
//               // ),
//               // SizedBox(width: 16),
//               // ElevatedButton(
//               //   onPressed: _presentDatePicker2,
//               //   child: Text('Fecha Fin'),
//               // ),
//               // SizedBox(width: 16),
//             ],
//           ),
//           // Container(
//           //   padding: EdgeInsets.all(16),
//           //   child: Text(
//           //     _selectedDate != null
//           //         ? 'Inicio: ${_selectedDate.toString().split(' ')[0]}- Fin:${_selectedDate2.toString().split(' ')[0]}'
//           //         : 'Ninguna fecha seleccionada',
//           //     style: TextStyle(fontSize: 18),
//           //   ),
//           // ),
//           ElevatedButton(
//             onPressed: () {
//               // Lógica para realizar la búsqueda
//               if (searchText.isEmpty) {
//                 Future.delayed(const Duration(seconds: 2), () {
//                   // Mostrar notificación de error al usuario
//                   showErrorNotification(
//                       context, 'Debe de ingresar la cedula del estudiante', 0);
//                 });
//               }else {
//                 _dataTableOn(_selectedDate, _selectedDate2);

//               }
//             },
//             child: Text('Buscar'),
//           ),
//           SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   DataColumn(label: Text('ID')),
//                   DataColumn(label: Text('Cedula')),
//                   DataColumn(label: Text('Nombre')),
//                   DataColumn(label: Text('Apellido')),
//                 ],
//                 rows: _dataListU.map((data) {
//                   // Asumimos que el formato de cada string es 'ID: <id>, Nombre: <nombre>, Apellido: <apellido>'
//                   final splitData =
//                       data.split(','); // Divide la cadena en partes
//                   final id = splitData[0].split(':')[1].trim(); // Extrae el ID
//                   final nombre =
//                       splitData[1].split(':')[1].trim(); // Extrae el nombre
//                   final apellido =
//                       splitData[2].split(':')[1].trim(); // Extrae el apellido
//                   final cedul =
//                       splitData[3].split(':')[1].trim(); // Extrae el apellido

//                   return DataRow(cells: [
//                     DataCell(Text(id)),
//                     DataCell(Text(cedul)),
//                     DataCell(Text(nombre)),
//                     DataCell(Text(apellido)),
//                   ]);
//                 }).toList(),
//               )),
//         ],
//       )),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';
import 'package:flutter_application/Notificacionescomp/notificaciones.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';

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
        title: Text('Bienvenido'),
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
  List<String> filteredDataList = []; // Lista para datos filtrados

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Establecer una fecha predeterminada
    _selectedDate2 = DateTime.now(); // Establecer otra fecha predeterminada

    // Llamar a _dataTableOn con las fechas seleccionadas al inicializar la pantalla
    _dataTableOn(_selectedDate, _selectedDate2);
  }

  void _dataTableOn(DateTime? _selectedDate, DateTime? _selectedDate2) async {
    final List<String> _dataListE = await _apiClient.dataTablePersonas();
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListU = _dataListE;
      filteredDataList = _dataListU; // Inicializa la lista filtrada
    });

    if (_dataListU.length == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        showErrorNotification(context, 'No se encontraron datos', 1);
      });
    }

    print('$_dataListU');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Personas'),
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
                      // Filtra los datos según el texto ingresado
                      filteredDataList = _dataListU.where((data) {
                        final splitData = data.split(',');
                        final id = splitData[0].split(':')[1].trim();
                        final cedula = splitData[3].split(':')[1].trim();
                        final nombre = splitData[1].split(':')[1].trim();
                        final apellido = splitData[2].split(':')[1].trim();

                        return id
                                .toLowerCase()
                                .contains(searchText.toLowerCase()) ||
                            cedula
                                .toLowerCase()
                                .contains(searchText.toLowerCase()) ||
                            nombre
                                .toLowerCase()
                                .contains(searchText.toLowerCase()) ||
                            apellido
                                .toLowerCase()
                                .contains(searchText.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por cédula, nombre, apellido o ID...',
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (searchText.isEmpty) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  showErrorNotification(
                      context, 'Debe ingresar un texto para buscar.', 0);
                });
              }
            },
            child: Text('Buscar'),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Cedula')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Apellido')),
                ],
                rows: filteredDataList.map((data) {
                  final splitData = data.split(',');
                  final id = splitData[0].split(':')[1].trim(); // Extrae el ID
                  final nombre =
                      splitData[1].split(':')[1].trim(); // Extrae el nombre
                  final apellido =
                      splitData[2].split(':')[1].trim(); // Extrae el apellido
                  final cedula =
                      splitData[3].split(':')[1].trim(); // Extrae la cédula

                  return DataRow(cells: [
                    DataCell(Text(id)),
                    DataCell(Text(cedula)),
                    DataCell(Text(nombre)),
                    DataCell(Text(apellido)),
                  ]);
                }).toList(),
              )),
        ],
      )),
    );
  }
}
