import 'package:flutter/material.dart';
import 'package:lumier_front/utils/app_styles.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/inicioBG.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Este Spacer ocupa 3 partes del espacio sobrante (empuja hacia abajo)
              const Spacer(flex: 1),

              // --- BLOQUE CENTRAL ---
              // 1. Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.movie_creation_outlined,
                  color: Colors.amber,
                  size: 50,
                ),
              ),

              const SizedBox(height: 24),

              // 2. Títulos
              Text(
                'Lumier',
                style: AppStyles.movieTitle.copyWith(color: Colors.amber, fontSize: 36),
              ),
              Text(
                'Tu cine personalizado',
                style: AppStyles.generic
              ),
              const SizedBox(height: 50), // Espacio entre título y botones
              // 3. Botones
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  'Registrarse',
                  style: AppStyles.buttonText,
                ),
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70, width: 1.5),
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  'Iniciar sesión',
                  style: AppStyles.buttonText.copyWith(color: Colors.white),
                ),
              ),

              // --- FIN BLOQUE CENTRAL ---

              // Este Spacer ocupa 2 partes (al ser menor que el de arriba, el bloque sube un poco)
              const Spacer(flex: 2),

              // 4. Pie de página
              Text(
                'Descubre películas personalizadas para ti',
                style: AppStyles.generic
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
