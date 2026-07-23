import 'package:flutter/material.dart';
import 'package:lumier_front/services/ListaService.dart';

import '../utils/app_styles.dart';

TextFormField estructuraFormField({
  required TextInputType keyboardType,
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData iconData,
  required int maxlength,
  bool obscureText = false,
  String? Function(String?)? customValidator,
}) {
  return TextFormField(
    keyboardType: keyboardType, // Tipo de teclado específico para cada campo
    controller: controller, // Controlador para manejar el texto ingresado
    obscureText: obscureText, // Oculta el texto para campos de contraseña
    maxLength: maxlength, // Máximo de caracteres permitidos
    style: AppStyles.dataValue, // Estilo del texto ingresado
    decoration: InputDecoration(
      counterText: "", // Oculta el contador visual
      labelText: labelText, // Etiqueta del campo (ej. "Nombre", "Email")
      labelStyle: AppStyles.label, // Estilo de la etiqueta
      hintText:
          hintText, // Texto de sugerencia dentro del campo (ej. "juanperez")
      hintStyle: AppStyles.generic.copyWith(
        color: Colors.white24,
      ), // Estilo del texto de sugerencia
      prefixIcon: Icon(iconData, color: Colors.grey),
      filled: true,
      fillColor: const Color.fromARGB(255, 35, 35, 35),
      enabledBorder: OutlineInputBorder(
        // Borde cuando el campo no está enfocado
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.12),
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        // Borde cuando el campo está enfocado
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.amber, width: 2.0),
      ),

      errorBorder: OutlineInputBorder(
        // Borde cuando hay un error de validación
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        // Borde cuando el campo está enfocado y tiene error
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Campo obligatorio';
      if (customValidator != null) return customValidator(value);
      return null;
    },
  );
}

//Snackbar pernalizado para mensajes de error
void snackbarResultado(BuildContext context, String mensaje, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // letra blanca, fondo rojo oscuro, con un poco de transparencia
      duration: Duration(seconds: 1), // Duración del Snackbar
      showCloseIcon: true,
      closeIconColor: Colors.white,
      content: Text(mensaje, style: AppStyles.generic),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  );
}

Widget opcionDeNavegacion({
  required BuildContext context,
  required String textoPregunta,
  required String textoAccion,
  required String ruta,
}) {
  return GestureDetector(
    onTap: () => Navigator.of(context).pushNamed(ruta),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
          children: [
            TextSpan(text: textoPregunta, style: AppStyles.body),
            TextSpan(
              text: textoAccion,
              style: AppStyles.buttonText.copyWith(color: Colors.amber),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget datoPerfil(String cifra, String etiqueta) {
  return Expanded(
    child: Column(
      children: [
        Text(
          cifra,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          etiqueta.toUpperCase(),
          style: AppStyles.label.copyWith(fontSize: 9, letterSpacing: 1),
        ),
      ],
    ),
  );
}

