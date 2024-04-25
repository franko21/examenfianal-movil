import 'package:flutter/material.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';
import 'package:flutter_application/Registrocomp/Registerpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

String nombreU = '';
String dniU = '';
List<String> _dataListU = [];
final ApiClient _apiClient = ApiClient();
void main() {
  runApp(const MyApp());
}

void _showErrorNotification(BuildContext context, String message, int c) {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecuaminerales',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Mostrar Splash Screen al principio
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Esperar 5 segundos y luego navegar a la página de login
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  title: const Text('Bienvenido'),
          ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 100),
            SizedBox(height: 20),
            Text(
              'Bienvenido Ecuaminerals',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: const Text('Login'),
          ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Usuario'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Contraseña'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _login(context);
          },
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Login'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            // Instancia de la pantalla de registro desde otra clase
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Registerpage()),
            );
          },
          child: const Text('Registrarse'),
        ),
      ],
    );
  }

  void _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    String role = '';

    setState(() {
      _isLoading = true;
    });

    try {
      final String loginSuccessful =
          await _apiClient.signinUser(username, password, role);
      if (loginSuccessful.isNotEmpty) {
        if (loginSuccessful.toString().split(' ')[0] == 'ADMIN') {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isLoading = false;
            });
            // Placeholder for login logic
            print('Login successful');
            nombreU = '${loginSuccessful.toString().split(' ')[1]} ${loginSuccessful.toString().split(' ')[2]}';
            nombreU = '${loginSuccessful.toString().split(' ')[1]} ${loginSuccessful.toString().split(' ')[2]}';
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WelcomeAdminScreen(),
              ),
            );
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            // Placeholder for login logic
            print('Login successful, Empleado $loginSuccessful.toString()');
            nombreU = '${loginSuccessful.toString().split(' ')[1]} ${loginSuccessful.toString().split(' ')[2]}';
            dniU = loginSuccessful.toString().split(' ')[3];
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
            setState(() {
              _isLoading = false;
            });
          });
        }
        // El inicio de sesión fue exitoso

        // Realiza otras acciones después del inicio de sesión
      } else {
        // El inicio de sesión falló
        print('Inicio de sesión fallido');

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isLoading = false;
          });
          // Mostrar notificación de error al usuario
          _showErrorNotification(
              context,
              'Inicio de sesión fallido, Revisa el usuario y la contrasenia',
              0);
        });
      }
    } catch (e) {
      // Manejo de errores (por ejemplo, problemas de red, errores del servidor, etc.)
      print('Error durante el inicio de sesión: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorNotification(context, 'Error: $e', 0);
    }

    // Simulating a network request
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido $nombreU'),
        ),
        body: const MyHomePage() //const Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(Icons.pets, size: 100),
        //       SizedBox(height: 20),
        //       Text(
        //         'Welcome to Cat Litter Sales!',
        //         style: TextStyle(fontSize: 24),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
      // Actualiza _dataListU con los nuevos datos
      _dataListU = dataListE;
    });

    if (_dataListU.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'No se encontraron datos', 1);
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
        title: const Text('Marcaciones Empleado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _dataListU = [];
              dniU = '';

              // Lógica para cerrar sesión
              // Por ejemplo, llamar a una función que maneje el cierre de sesión
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
                  // Lógica para realizar la búsqueda
                  if (_selectedDate == null) {
                    Future.delayed(const Duration(seconds: 2), () {
                      // Mostrar notificación de error al usuario
                      _showErrorNotification(
                          context, 'Debe de seleccionar la fecha de inicio', 0);
                    });
                  } else if (_selectedDate2 == null) {
                    Future.delayed(const Duration(seconds: 2), () {
                      // Mostrar notificación de error al usuario
                      _showErrorNotification(
                          context, 'Debe de seleccionar la fecha fin', 0);
                    });
                  } else if (_selectedDate2?.isBefore(_selectedDate!) ??
                      false) {
                    Future.delayed(const Duration(seconds: 2), () {
                      // Mostrar notificación de error al usuario
                      _showErrorNotification(
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
                  ? 'Inicio: ${_selectedDate.toString().split(' ')[0]}- Fin:${_selectedDate2.toString().split(' ')[0]}'
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
                rows: _dataListU.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.split(',')[2])),
                    DataCell(Text(data.split(',')[3])),
                    DataCell(Text(data.split(',')[4].split(' ')[0])),
                    DataCell(Text(data.split(',')[4].split(' ')[1])),
                    DataCell(Text(
                        data.split(',')[5] ?? '')),
                    DataCell(Text(data.split(',')[6])),
                    DataCell(Text(data.split(',')[7])),
                    DataCell(Text(data.split(',')[8])),
                  ]);
                }).toList(),
              )),
        ],
      )),
    );
  }
}

class WelcomeAdminScreen extends StatelessWidget {
  const WelcomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido $nombreU'),
        ),
        body: const MyHomeAdminPage() //const Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(Icons.pets, size: 100),
        //       SizedBox(height: 20),
        //       Text(
        //         'Welcome to Cat Litter Sales!',
        //         style: TextStyle(fontSize: 24),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}

class MyHomeAdminPage extends StatefulWidget {
  const MyHomeAdminPage({super.key});

  @override
  _MyHomeAdminPageState createState() => _MyHomeAdminPageState();
}

class _MyHomeAdminPageState extends State<MyHomeAdminPage> {
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  String searchText = '';

  void _dataTableOn(DateTime? selectedDate, DateTime? selectedDate2) async {
    final List<String> dataListE = await _apiClient.dataTableET(
      '${selectedDate.toString().split(' ')[0]}T00:00:00',
      '${selectedDate2.toString().split(' ')[0]}T23:59:59',
      searchText,
    );
    setState(() {
      // Actualiza _dataListU con los nuevos datos
      _dataListU = dataListE;
    });

    if (_dataListU.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        // Mostrar notificación de error al usuario
        _showErrorNotification(context, 'No se encontraron datos', 1);
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
        title: const Text('Marcaciones Talento Humano'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _dataListU = [];
              dniU = '';
              // Lógica para cerrar sesión
              // Por ejemplo, llamar a una función que maneje el cierre de sesión
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              });
              print('Cerrando sesión...');
            },
          ),
        ],
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
                  decoration: const InputDecoration(
                    hintText: 'Cedula empleado...',
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              _selectedDate != null
                  ? 'Inicio: ${_selectedDate.toString().split(' ')[0]}- Fin:${_selectedDate2.toString().split(' ')[0]}'
                  : 'Ninguna fecha seleccionada',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para realizar la búsqueda
              if (searchText.isEmpty) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  _showErrorNotification(
                      context, 'Debe de ingresar la cedula del usuario', 0);
                });
              } else if (_selectedDate == null) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  _showErrorNotification(
                      context, 'Debe de seleccionar la fecha de inicio', 0);
                });
              } else if (_selectedDate2 == null) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  _showErrorNotification(
                      context, 'Debe de seleccionar la fecha fin', 0);
                });
              } else if (_selectedDate2?.isBefore(_selectedDate!) ?? false) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Mostrar notificación de error al usuario
                  _showErrorNotification(
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
                rows: _dataListU.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.split(',')[2])),
                    DataCell(Text(data.split(',')[3])),
                    DataCell(Text(data.split(',')[4].split(' ')[0])),
                    DataCell(Text(data.split(',')[4].split(' ')[1])),
                    DataCell(Text(
                        data.split(',')[5] ?? '')),
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

String getDayOfWeek(String dateString) {
  // Parse the input string to a DateTime object
  final DateTime? parsedDate = DateTime.tryParse(dateString);

  if (parsedDate == null) {
    // Handle invalid date format
    return 'Fecha inválida';
  }

  // Get the day of the week (0 = Monday, 6 = Sunday)
  final int dayOfWeek = parsedDate.weekday;

  // Convert the day of the week to a readable string
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
