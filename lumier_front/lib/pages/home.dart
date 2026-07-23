import 'package:flutter/material.dart';
import 'package:lumier_front/globales.dart';
import 'package:lumier_front/services/RecomendacionesService.dart';
import 'package:lumier_front/utils/app_styles.dart';
import '../models/Peliculas.dart';
import '../services/PeliculaService.dart';
import '../widgets/movieWidgets.dart';
import '../widgets/searchDelegate.dart';
import '../widgets/userWidgets.dart';

// Para el jsonEncode/decode
// import 'package:http/http.dart' as http; // Descomenta cuando instales el paquete

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  // Variables y métodos para manejar la lógica de la página
  late Future<List<Pelicula>> recomendacionesFuture;
  late Future<List<Pelicula>> topRatedFuture;
  late Future<List<Pelicula>> superheroMoviesFuture;
  late Future<List<Pelicula>> actionMoviesFuture;
  late Future<List<Pelicula>> animationMoviesFuture;
  late Future<List<Pelicula>> crimeMoviesFuture;
  final PeliculaService peliculaService = PeliculaService();
  final RecomendacionesService recomendacionesService =
      RecomendacionesService();

  @override
  void initState() {
    super.initState();
    // Cargamos las películas al iniciar la página
    recomendacionesFuture = recomendacionesService.obtenerRecomendaciones(
      userIdLogueado!,
    );
    topRatedFuture = peliculaService.getMovies("top_rated");
    superheroMoviesFuture = peliculaService.getSuperheroMovies();
    actionMoviesFuture = peliculaService.getGenreMovies(
      28,
    ); // ID del género de acción
    animationMoviesFuture = peliculaService.getGenreMovies(
      16,
    ); // ID del género de animación
    crimeMoviesFuture = peliculaService.getGenreMovies(
      80,
    ); // ID del género de crimen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'LUMIER',
          style: AppStyles.movieTitle.copyWith(color: Colors.amber),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PeliculaSearchDelegate(peliculaService),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SegmentedButton para elegir entre "Películas", "Series" y "Personas"
            // Por ahora solo "Películas" estará activo, las otras dos mostrarán un mensaje de "Próximamente"
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: 'peliculas',
                    label: Text(
                      'Películas',
                      style: AppStyles.buttonText.copyWith(fontSize: 12),
                    ),
                  ),
                  ButtonSegment(
                    value: 'series',
                    label: Text(
                      'Series',
                      style: AppStyles.buttonText.copyWith(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  ButtonSegment(
                    value: 'personas',
                    label: Text(
                      'Personas',
                      style: AppStyles.buttonText.copyWith(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
                selected: const {'peliculas'},
                // Estilo personalizado para el SegmentedButton acorde con el diseño de la app
                style: SegmentedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F1F1F),
                  selectedForegroundColor: Colors.black,
                  selectedBackgroundColor: Colors.amber,
                  disabledForegroundColor: Colors.white54,
                  disabledBackgroundColor: Colors.white24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onSelectionChanged: (newSelection) {
                  // Por ahora no hacemos nada, pero aquí podrías cambiar el estado para mostrar diferentes secciones
                  if (newSelection.contains('series') ||
                      newSelection.contains('personas')) {
                    snackbarResultado(
                      context,
                      "✨ ¡Próximamente en Lumier!",
                      Colors.blue[700]!,
                    );
                  }
                },
              ),
            ),
            FutureBuilder<List<Pelicula>>(
              future: recomendacionesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 250,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }

                final destacada = snapshot.data!.first;
                final resto = snapshot.data!.sublist(1);

                return Column(
                  children: [
                    // Banner grande con la primera recomendación
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/movie_details',
                        arguments: destacada,
                      ),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        height:
                            260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(
                              destacada.backdropPath.isNotEmpty
                                  ? destacada.backdropPath
                                  : destacada.posterPath,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: .8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recomendada para ti',
                                style: AppStyles.sectionTitle.copyWith(
                                  color: Colors.amber,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                destacada.titulo,
                                style: AppStyles.movieTitle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Carrusel con el resto
                    if (resto.isNotEmpty)
                      seccionPeliculasLista('Para ti', resto),
                  ],
                );
              },
            ),
            seccionPeliculas("Mejor Calificadas", topRatedFuture),
            seccionPeliculas("Superhéroes", superheroMoviesFuture),
            seccionPeliculas("Acción", actionMoviesFuture),
            seccionPeliculas("Animación", animationMoviesFuture),
            seccionPeliculas("Crimen", crimeMoviesFuture),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
