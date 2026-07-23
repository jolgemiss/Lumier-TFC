import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumier_front/pages/home.dart';
import 'package:lumier_front/pages/login.dart';
import 'package:lumier_front/pages/movie_details.dart';
import 'package:lumier_front/pages/register.dart';
import 'package:lumier_front/pages/user_proflie.dart';
import 'package:lumier_front/pages/welcome.dart';

void main() {
  runApp(Principal());
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumier',
      debugShowCheckedModeBanner:
          false, // Opcional: quita la banda roja de "Debug"
      // CONFIGURACIÓN DE DISEÑO GLOBAL
      theme: ThemeData(
        brightness: Brightness.dark, // Define que la app es oscura por defecto
        // Esto aplica el estilo a las AppBar de forma global
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        fontFamily: "Montserrat", // Establece la fuente global para toda la app
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.amber, // El color de la "gota"
          cursorColor: Colors.amber, // El color del palito (cursor)
          selectionColor: Color.fromARGB(
            100,
            255,
            191,
            0,
          ), // El sombreado al resaltar texto
        ),
      ),

      initialRoute: "/welcome",
      routes: {
        "/welcome": (BuildContext context) => Welcome(),
        "/register": (BuildContext context) => Register(),
        "/login": (BuildContext context) => Login(),
        "/home": (BuildContext context) => Home(),
        "/movie_details": (BuildContext context) => MovieDetails(),
        "/profile": (BuildContext context) => UserProflie(),
        
      },
    );
  }
}
