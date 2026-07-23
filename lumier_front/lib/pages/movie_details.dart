import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lumier_front/globales.dart';
import 'package:lumier_front/models/ContenidoListas.dart';
import 'package:lumier_front/services/InteraccionService.dart';
import 'package:lumier_front/services/PeliculaService.dart';
import 'package:lumier_front/utils/colorUtils.dart';
import 'package:lumier_front/widgets/userWidgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/Lista.dart';
import '../models/Peliculas.dart';
import '../models/Resena.dart';
import '../services/ListaService.dart';
import '../utils/app_styles.dart';
import '../widgets/movieWidgets.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  MovieDetailsState createState() => MovieDetailsState();
}

class MovieDetailsState extends State<MovieDetails> {
  final peliculaService = PeliculaService();
  double puntuacion = 0;
  final TextEditingController comentarioController = TextEditingController();

  final listaService = Listaservice();
  late Future<List<Lista>> listasFuture;

  @override
  void initState() {
    super.initState();
    // ✅ Se crean UNA sola vez
    listasFuture = listaService.obtenerListas(userIdLogueado!);
  }

  Future<Pelicula>? movieFuture;
  Future<List<Resena>>? resenasFuture;
  String? categoriaSeleccionada;
  @override
  Widget build(BuildContext context) {
    // Recibimos los argumentos y los convertimos al tipo Pelicula
    final peli = ModalRoute.of(context)!.settings.arguments as Pelicula;
    final interaccionesService = InteraccionService();
    movieFuture ??= peliculaService.getMovieDetails(peli.id);
    resenasFuture ??= peliculaService.obtenerResenas(peli.id);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // Barra de navegacion inferior con iconos de home, search y profile
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Home es el primer ícono
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
                      Navigator.pushNamed(context, '/profile');
          }
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: movieFuture, // Usamos el ID para obtener los detalles
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            final Pelicula peli = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    // 1. EL LOGO (Sigue siendo un Future separado)
                    title: FutureBuilder<String?>(
                      future: peliculaService.getMovieLogo(
                        peli.id,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Un espacio vacío del mismo tamaño para que el título no salte
                          return const SizedBox(height: 40);
                        }
                        if (snapshot.hasData && snapshot.data != null) {
                          return Image.network(
                            snapshot.data!,
                            height: 40,
                            fit: BoxFit.contain,
                          );
                        }
                        // Si no hay logo, mostramos el texto como plan B
                        return Text(
                          peli.titulo,
                          style: AppStyles.movieTitle.copyWith(
                            color: Colors.amber,
                          ),
                        );
                      },
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 3. LA IMAGEN DE FONDO
                        Image.network(
                          peli.backdropPath,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),

                        // 4. EL DEGRADADO
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black.withValues(alpha: 0.9),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Aquí vendría el resto de la info (Sinopsis, botones, etc.)
                // --- SLIVER LIST ---
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // VALORACIÓN
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              // Row principal para dividir la pantalla en dos
                              children: [
                                // LADO IZQUIERDO: VALORACIÓN PROFESIONAL
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "MEDIOS DE PRENSA",
                                        style: AppStyles.label.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: .05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.white10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                "${(peli.voteAverage * 10).toInt()}",
                                                style: AppStyles.dataValue.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: ratingColor(
                                                    peli.voteAverage,
                                                  ), // Un toque de color para diferenciar
                                                ),
                                              ),
                                              const Text(
                                                " / 100",
                                                style: AppStyles.label,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SEPARADOR VISUAL (Opcional, una línea vertical sutil)
                                divisorVertical(),
                                // LADO DERECHO: VALORACIÓN USUARIOS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "USUARIOS",
                                        style: AppStyles.label.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FutureBuilder(
                                        future: resenasFuture,
                                        builder: (context, snapshot) {
                                          final cantidad =
                                              snapshot.data?.length ?? 0;
                                          final media = cantidad > 0
                                              ? snapshot.data!
                                                        .map(
                                                          (r) => r.puntuacion,
                                                        )
                                                        .reduce(
                                                          (a, b) => a + b,
                                                        ) /
                                                    cantidad
                                              : 0.0;
                                          return Column(
                                            children: [
                                              RatingBarIndicator(
                                                rating:
                                                    media, // Aquí peli.userRating
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                itemCount: 5,
                                                itemSize: 18.0,
                                                direction: Axis.horizontal,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "${media.toStringAsFixed(1)} / 5",
                                                style: AppStyles.dataValue
                                                    .copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              // --- NUEVO: Cantidad de valoraciones ---
                                              Text(
                                                cantidad == 0
                                                    ? "Sin valoraciones"
                                                    : "$cantidad valoracion${cantidad == 1 ? '' : 'es'}",
                                                style: AppStyles.label.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          divider(),

                          // FILA DE DATOS (Usamos 'peli' directamente, sin FutureBuilder extra)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              datoItem('Estreno', peli.releaseDate),
                              datoItem('Duración', "${peli.runtime} min"),
                              datoItem(
                                'Idioma',
                                peli.originalLanguage.toUpperCase(),
                              ),
                            ],
                          ),

                          divider(),

                          // SECCIÓN DE GÉNEROS
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Géneros",
                                  style: AppStyles.label.copyWith(
                                    fontSize: 18,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  peli.generos.isNotEmpty
                                      ? peli.generos.join(', ')
                                      : "Sin géneros disponibles",
                                  style: AppStyles.body,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),

                          divider(),

                          // SECCIÓN DE SINOPSIS
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sinopsis",
                                  style: AppStyles.label.copyWith(
                                    fontSize: 18,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  peli.overview.isNotEmpty
                                      ? peli.overview
                                      : "Sin sinopsis disponible",
                                  style: AppStyles.body,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),

                          divider(),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Botón de Película Vista
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          // 1. Guardamos el resultado del backend (true si guardado, false si eliminado)
                                          bool resultado =
                                              await interaccionesService
                                                  .toggleInteraccion(
                                                    idUsuario: userIdLogueado!,
                                                    tmdbId: peli.id,
                                                    tipoAccion: 'VISTA',
                                                    tituloPelicula: peli.titulo,
                                                    urlPoster: peli.posterPath,
                                                  );

                                          if (resultado) {
                                            snackbarResultado(
                                              context,
                                              "Película añadida a Vistas",
                                              Colors.green[600]!,
                                            );
                                          } else {
                                            snackbarResultado(
                                              context,
                                              "Película eliminada de Vistas!",
                                              Colors.red[600]!,
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Colors.greenAccent,
                                          size: 18,
                                        ),
                                        label: Text(
                                          'VISTA',
                                          style: AppStyles.buttonText.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.05),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: BorderSide(
                                              color: Colors.white10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Botón de Favoritos
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          // 1. Guardamos el resultado del backend
                                          bool resultado =
                                              await interaccionesService
                                                  .toggleInteraccion(
                                                    idUsuario: userIdLogueado!,
                                                    tmdbId: peli.id,
                                                    tipoAccion: 'FAVORITA',
                                                    tituloPelicula: peli.titulo,
                                                    urlPoster: peli.posterPath,
                                                  );
                                          if (resultado) {
                                            snackbarResultado(
                                              context,
                                              "Película añadida a Favoritos",
                                              Colors.green[600]!,
                                            );
                                          } else {
                                            snackbarResultado(
                                              context,
                                              "Película eliminada de Favoritos!",
                                              Colors.red[600]!,
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.favorite_border_rounded,
                                          color: Colors.pinkAccent,
                                          size: 18,
                                        ),
                                        label: Text(
                                          'FAVORITA',
                                          style: AppStyles.buttonText.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.05),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: BorderSide(
                                              color: Colors.white10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                FutureBuilder<List<Lista>>(
                                  future: listasFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasData) {
                                      final listas = snapshot.data!;

                                      if (listas.isEmpty) {
                                        return Container(
                                          padding: const EdgeInsets.all(
                                            16,
                                          ), // Aire interior
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.04,
                                            ), // Fondo suave
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ), // Bordes redondeados
                                            border: Border.all(
                                              color: Colors.white10,
                                            ), // Borde sutil
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .warning,
                                                color: Colors.white54,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Crea una lista para guardar esta película',
                                                style: AppStyles.label.copyWith(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return DropdownButtonFormField<String>(
                                        value: categoriaSeleccionada,
                                        // El hint ahora describe la acción exacta que va a realizar
                                        hint: Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .bookmark_add_rounded, // Icono de añadir a lista/marcador
                                              color: Colors.white.withValues(
                                                alpha: 0.6,
                                              ),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Añadir a una lista...',
                                              style: AppStyles.buttonText
                                                  .copyWith(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.6),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        // Fondo del menú flotante (Oscuro Lumier)
                                        dropdownColor: const Color(0xFF141414),
                                        icon: const Icon(
                                          Icons.add_circle_outline_rounded,
                                          color: Colors.white60,
                                          size: 20,
                                        ),
                                        style: AppStyles.buttonText.copyWith(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        isExpanded: true,
                                        // Mapeamos las listas disponibles
                                        items: listas
                                            .map(
                                              (listas) =>
                                                  DropdownMenuItem<String>(
                                                    value: listas.id.toString(),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.list_rounded,
                                                          color: Colors.amber,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          listas.nombreLista,
                                                          style: AppStyles
                                                              .dataValue,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                        onChanged:
                                            (
                                              String? nuevaListaSeleccionada,
                                            ) async {
                                              if (nuevaListaSeleccionada ==
                                                  null)
                                                return;

                                              setState(() {
                                                categoriaSeleccionada =
                                                    nuevaListaSeleccionada;
                                              });

                                              final listaEncontrada = listas
                                                  .firstWhere(
                                                    (lista) =>
                                                        lista.id.toString() ==
                                                        nuevaListaSeleccionada,
                                                  );

                                              final contenidoListasDTO =
                                                  ContenidoListasDTO(
                                                    tmdbId: peli.id,
                                                    idLista:
                                                        listaEncontrada.id!,
                                                    titulo: peli.titulo,
                                                    urlPoster: peli.posterPath,
                                                  );

                                              try {
                                                await listaService
                                                    .agregarPeliculaLista(
                                                      contenidoListasDTO,
                                                    );

                                                snackbarResultado(
                                                  context,
                                                  'Pelicula añadida correctamente',
                                                  Colors.green[700]!,
                                                );
                                              } catch (e) {
                                                snackbarResultado(
                                                  context,
                                                  'La película ya está guardada en esta lista.',
                                                  Colors.red[700]!,
                                                );
                                              }
                                            },
                                        // Contenedor exterior estilizado (Fondo integrado con la UI)
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white.withValues(
                                            alpha: 0.04,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.white10,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.white.withValues(
                                                alpha: 0.25,
                                              ),
                                              width: 1.2,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),

                          divider(),

                          // SECCIÓN DE RESEÑAS
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Center(
                                  child: RatingBar.builder(
                                    initialRating: puntuacion,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 40,
                                    itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        puntuacion = rating;
                                      });
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    puntuacion == 0
                                        ? "Toca las estrellas para votar"
                                        : puntuacion == 1
                                        ? "Pérdida de tiempo 😡"
                                        : puntuacion == 2
                                        ? "No me ha convencido 👎"
                                        : puntuacion == 3
                                        ? "Entretenida, sin más 🍿"
                                        : puntuacion == 4
                                        ? "¡Muy recomendada! ✨"
                                        : "¡Obra maestra! 🏆",
                                    style: AppStyles.label.copyWith(
                                      color: puntuacion == 0
                                          ? Colors.amber
                                          : puntuacion == 1
                                          ? Colors.redAccent[700]
                                          : puntuacion == 2
                                          ? Colors.orangeAccent[700]
                                          : puntuacion == 3
                                          ? Colors.amber
                                          : puntuacion == 4
                                          ? Colors.greenAccent[400]
                                          : Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),

                                TextField(
                                  autofocus: false,
                                  controller: comentarioController,
                                  maxLength: 500,
                                  maxLines:
                                      10, // Permite varias líneas para reseñas largas
                                  style: AppStyles
                                      .dataValue, // Texto que escribe el usuario
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    hintText:
                                        "Cuéntanos qué te ha parecido la película...",
                                    hintStyle: const TextStyle(
                                      color: Colors.white24,
                                      fontSize: 14,
                                    ),
                                    // Color de fondo del recuadro
                                    filled: true,
                                    fillColor: Colors.grey[900],
                                    // Borde cuando NO está seleccionado
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Colors.white10,
                                      ),
                                    ),
                                    // Borde cuando el usuario hace clic para escribir
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                        width: 2,
                                      ), // Toque dorado
                                    ),
                                    // Espaciado interno del texto
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (puntuacion == 0) {
                                        snackbarResultado(
                                          context,
                                          '¡Debes puntuar la película para poder enviar la reseña!',
                                          Colors.redAccent[700]!,
                                        );
                                      } else {
                                        final mensaje = await peliculaService
                                            .publicarResena(
                                              tmdbId: peli.id,
                                              tituloPelicula: peli.titulo,
                                              usuarioId: userIdLogueado!,
                                              comentario:
                                                  comentarioController.text,
                                              puntuacion: puntuacion,
                                              urlPoster: peli.posterPath,
                                            );

                                        if (mensaje != null) {
                                          snackbarResultado(
                                            context,
                                            mensaje, // "Reseña publicada" o "Reseña actualizada"
                                            Colors.green[700]!,
                                          );
                                        } else {
                                          snackbarResultado(
                                            context,
                                            'No se ha podido publicar la reseña, inténtalo más tarde',
                                            Colors.red[700]!,
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      'Publicar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),

                                divider(),

                                FutureBuilder<List<Resena>>(
                                  future: resenasFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Text(
                                        "Aún no hay reseñas. ¡Sé el primero!",
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final resena = snapshot.data![index];
                                        return Card(
                                          elevation:
                                              2, // Le da una sombra sutil para despegarla del fondo
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    // Círculo con la inicial del usuario (estilo perfil)
                                                    CircleAvatar(
                                                      backgroundColor: Colors
                                                          .amber
                                                          .withOpacity(0.2),
                                                      radius: 18,
                                                      child: Text(
                                                        resena.usuarioNombre[0]
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          color: Colors.amber,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    // Nombre y Estrellas
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            resena
                                                                .usuarioNombre,
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          RatingBarIndicator(
                                                            rating: resena
                                                                .puntuacion,
                                                            itemBuilder:
                                                                (
                                                                  context,
                                                                  index,
                                                                ) => const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                            itemCount: 5,
                                                            itemSize: 14.0,
                                                            direction:
                                                                Axis.horizontal,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      timeago.format(
                                                        DateTime.parse(
                                                          resena.fecha,
                                                        ),
                                                        locale: 'es',
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                                  child: Divider(
                                                    height: 1,
                                                    color: Colors.white10,
                                                  ), // Una línea separadora fina
                                                ),
                                                // El comentario con un estilo más limpio
                                                Text(
                                                  resena.comentario,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    height:
                                                        1.4, // Mejora la lectura del párrafo
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
