import 'package:flutter/material.dart';
import 'package:lumier_front/utils/app_styles.dart';

import '../models/Peliculas.dart';
import '../services/PeliculaService.dart';

class PeliculaSearchDelegate extends SearchDelegate<Pelicula?> {
  final PeliculaService peliculaService;

  PeliculaSearchDelegate(this.peliculaService);

  @override
  String get searchFieldLabel => 'Buscar película...';

  @override
  TextStyle get searchFieldStyle =>
      AppStyles.dataValue;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: AppStyles.generic.copyWith(
        color: Colors.white24,
      ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => buildResultados(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(
        child: Text(
          'Escribe el nombre de una película',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }
    return buildResultados(context);
  }

  Widget buildResultados(BuildContext context) {
    return FutureBuilder<List<Pelicula>>(
      future: peliculaService.buscarPeliculas(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Sin resultados',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final peli = snapshot.data![index];
            return ListTile(
              leading: peli.posterPath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        peli.posterPath,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.movie, color: Colors.amber),
              title: Text(
                peli.titulo,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                peli.releaseDate,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              onTap: () {
                close(context, peli);
                Navigator.pushNamed(context, '/movie_details', arguments: peli);
              },
            );
          },
        );
      },
    );
  }
}
