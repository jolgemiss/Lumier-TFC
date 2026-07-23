import 'package:flutter/material.dart';

class AppStyles {
  // --- MONTSERRAT (Títulos, botones y etiquetas) ---
  
  // Título de la película en el Home y Detalles
  static const TextStyle movieTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 20,
    color: Colors.white,
  );

  // Secciones (Populares, En Cines, Película de la semana)
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: Colors.white,
  );

  // Etiquetas de la ficha técnica (Estreno, Duración...)
  static const TextStyle label = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 13,
    color: Colors.grey, // Un gris suave para que no compita con el valor
  );

  // Valores de la ficha técnica (2026-04-01, 98 min...)
  static const TextStyle dataValue = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Colors.white,
  );

  // Texto de los botones (Registrarse, Iniciar Sesión)
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: Colors.black, // Texto negro sobre botón amarillo
  );

  // --- POPPINS (Cuerpo y lectura larga) ---

  // Sinopsis y descripción de la película
  static const TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 15,
    height: 1.6, // Un buen interlineado para que la sinopsis se lea bien
    color: Colors.white70, // No blanco puro para no cansar la vista
  );

  // Texto genérico (mensajes de confirmación, ajustes, textos de ayuda)
  static const TextStyle generic = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.white,
  );
}