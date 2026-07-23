import 'package:flutter/material.dart';
import 'package:lumier_front/services/RegisterService.dart';
import 'package:lumier_front/widgets/userWidgets.dart';

import '../utils/app_styles.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    surnameCtrl.dispose();
    emailCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Flecha de color blanco para volver atrás
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'LUMIER',
          style: AppStyles.movieTitle.copyWith(color: Colors.amber),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Form(
          key: _formKey, // conecta el Form con la GlobalKey
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // stretch hace que los campos y botones
              // ocupen todo el ancho disponible
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  height: 70,
                  width: 70,
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.movie_creation,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16), // espacio entre el icono y el título
                Text(
                  'Crea tu cuenta en Lumier',
                  textAlign: TextAlign.center,
                  style: AppStyles.sectionTitle,
                ),
                SizedBox(
                  height: 16,
                ), // espacio entre el texto y el primer campo
                estructuraFormField(
                  keyboardType: TextInputType.name,
                  controller: nameCtrl,
                  labelText: 'Nombre',
                  hintText: "Nicolás",
                  iconData: Icons.person_outline, // Solo pasamos el IconData
                  maxlength: 100,
                ),
                SizedBox(height: 16), // espacio entre campos

                estructuraFormField(
                  keyboardType: TextInputType.name,
                  controller: surnameCtrl,
                  labelText: 'Apellidos',
                  hintText: "Mansilla Mantiñan",
                  iconData: Icons.person_outline, // Solo pasamos el IconData
                  maxlength: 100,
                ),
                SizedBox(height: 16), // espacio entre campos

                estructuraFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailCtrl,
                  labelText: 'Email',
                  hintText: "ejemplo@correo.com",
                  iconData: Icons.email_outlined, // Solo pasamos el IconData
                  maxlength: 150,
                  customValidator: (value) {
                    // 1. Definimos la "RegExp" (Expresión Regular)
                    // ^[a-zA-Z0-9.]+  -> Acepta letras, números y puntos al principio
                    // @               -> Obliga a que exista el símbolo arroba
                    // [a-zA-Z0-9]+    -> Acepta el nombre del dominio (ej: gmail)
                    // \.              -> Obliga a que haya un punto (.)
                    // [a-zA-Z]+       -> Acepta la extensión (ej: com, es, net)
                    final emailRegExp = RegExp(
                      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                    );

                    // 2. Comprobamos si lo que escribió el usuario coincide con el patrón
                    if (!emailRegExp.hasMatch(value!)) {
                      return 'Introduce un correo válido (ej: usuario@web.com)';
                    }

                    // 3. Si todo está bien, devolvemos null (sin error)
                    return null;
                  },
                ),

                SizedBox(height: 16), // espacio entre campos

                estructuraFormField(
                  keyboardType: TextInputType.text,
                  controller: usernameCtrl,
                  labelText: 'Nombre de usuario',
                  hintText: "nicolasmansilla",
                  iconData:
                      Icons.account_circle_outlined, // Solo pasamos el IconData
                  maxlength: 50,
                ),
                SizedBox(height: 16), // espacio entre campos

                estructuraFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordCtrl,
                  labelText: 'Contraseña',
                  hintText: 'Mínimo 6 caracteres',
                  iconData: Icons.lock_outline,
                  maxlength: 50,
                  obscureText: true, // Indica que es contraseña
                  customValidator: (value) {
                    if (value!.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // espacio entre campos
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Mostramos un indicador de carga si quieres, pero vamos al grano:
                      final service = RegisterService();

                      final error = await service.enviarRegistro(
                        nameCtrl.text,
                        surnameCtrl.text,
                        emailCtrl.text,
                        usernameCtrl.text,
                        passwordCtrl.text,
                      );

                      // Verificamos si el widget sigue "vivo" antes de usar el context
                      // (Buena práctica en Flutter tras un await)
                      if (!mounted) return;

                      if (error == null) {
                        // ÉXITO: Registro completado
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login",
                          (route) => false,
                        );
                      } else {
                        // ERROR: El backend nos ha dicho algo (email duplicado, etc.)
                        snackbarResultado(context, error, Colors.redAccent[700]!);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Enviar', style: AppStyles.buttonText,),
                ),

                const SizedBox(height: 16),

                opcionDeNavegacion(
                  context: context,
                  textoPregunta: '¿Ya tienes una cuenta? ',
                  textoAccion: 'Inicia sesión',
                  ruta: '/login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
