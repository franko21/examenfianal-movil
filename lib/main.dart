import 'package:flutter/material.dart';
import 'package:flutter_application/Registrocomp/ApiClient.dart';
import 'package:flutter_application/Registrocomp/Registerpage.dart';

void main() {
  runApp(const MyApp());
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

    await _apiClient.signinUser(username, password);

    setState(() {
      _isLoading = true;
    });

    // Simulating a network request
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      // Placeholder for login logic
      print('Login successful');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    });
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: MyHomePage() //const Center(
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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  List<String> _dataList = [];
  final ApiClient _apiClient = ApiClient();

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
        title: Text('Marcaciones'),
      ),
      body: Column(
        children: [
          Row(
            children: [
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
              ElevatedButton(
                onPressed: () {
                  // Lógica para realizar la búsqueda
                  _apiClient.dataTableE(
                      _dataList,
                      '${_selectedDate.toString().split(' ')[0]} 00:00:00',
                      '${_selectedDate2.toString().split(' ')[0]} 23:59:59');
                  print('Búsqueda realizada para fecha $_selectedDate');
                },
                child: Text('Buscar'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              _selectedDate != null
                  ? 'Fecha seleccionada: ${_selectedDate}'
                  : 'Ninguna fecha seleccionada',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Terminal')),
                  DataColumn(label: Text('Area')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Hora')),
                  DataColumn(label: Text('Día')),
                ],
                rows: _dataList.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.split(',')[0])),
                    DataCell(Text(data.split(',')[1])),
                    DataCell(Text(data.split(',')[11])),
                    DataCell(Text(data.split(',')[12])),
                    DataCell(Text(data.split(',')[6].split(' ')[0])),
                    DataCell(Text(data.split(',')[6].split(' ')[1])),
                    DataCell(Text(getDayOfWeek(data.split(',')[6]))),
                  ]);
                }).toList(),
              )),
        ],
      ),
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
