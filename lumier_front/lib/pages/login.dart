import 'package:flutter/material.dart';
import 'package:lumier_front/services/LoginService.dart';
import 'package:lumier_front/utils/app_styles.dart';
import 'package:lumier_front/widgets/userWidgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
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
                  'Inicia sesión en Lumier',
                  textAlign: TextAlign.center,
                  style: AppStyles.sectionTitle,
                ),
                SizedBox(
                  height: 16,
                ), // espacio entre el texto y el primer campo
                estructuraFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailCtrl,
                  labelText: 'Email',
                  hintText: "",
                  iconData: Icons.email_outlined, // Solo pasamos el IconData
                  maxlength: 150,
                ),
                SizedBox(height: 16), // espacio entre campos

                estructuraFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordCtrl,
                  labelText: 'Contraseña',
                  hintText: '',
                  iconData: Icons.lock_outline,
                  maxlength: 50,
                  obscureText: true, // Indica que es contraseña
                ),
                SizedBox(height: 16), // espacio entre campos
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // 2. Extraemos los datos de los controladores
                      String email = emailCtrl.text;
                      String password = passwordCtrl.text;

                      // 3. Llamamos al servicio de Login
                      final service = Loginservice();
                      final error = await service.enviarLogin(
                        email,
                        password,
                      );

                      // 4. Verificamos si el widget sigue montado
                      if (!mounted) return;

                      if (error == null) {
                        // ÉXITO: Usuario autenticado correctamente
                        // Usamos pushNamedAndRemoveUntil para que no pueda volver atrás al login
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      } else {
                        // ERROR: Mostramos el error que viene del backend (ej: "Contraseña incorrecta")
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
                  child: Text('Iniciar sesión', style: AppStyles.buttonText,),
                ),

                const SizedBox(height: 16),

                opcionDeNavegacion(
                  context: context,
                  textoPregunta: '¿No tienes una cuenta? ',
                  textoAccion: 'Regístrate',
                  ruta: '/register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
