import 'package:flutter/material.dart';
import 'package:flutter_application/Logincomp/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecuaminerales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Mostrar Splash Screen al principio
    );
  }
}

class SplashScreen extends StatefulWidget {
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
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build,
                size: 100,
                color: Colors
                    .orange), 
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

 // @override
  //Widget build(BuildContext context) {
  //  return Scaffold(
    //  appBar: AppBar(),
      //body: Center(
        //child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //children: [
            //Image.asset(
              //'imagenes/ecua1.png',
              //width: 100,
              //height: 100,
            //),
            //SizedBox(height: 20),
            //Text(
            //  'Bienvenido Ecuaminerals',
           //   style: TextStyle(fontSize: 24),
            //),
          //],
       // ),
     // ),
  //  );
  //}
//}
