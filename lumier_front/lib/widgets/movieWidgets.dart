import 'package:flutter/material.dart';
import 'package:lumier_front/utils/app_styles.dart';

import '../models/Peliculas.dart';

Widget seccionPeliculas(String titulo, Future<List<Pelicula>> future) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      mostrarCategoria(titulo),
      FutureBuilder<List<Pelicula>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return carruselPeliculasReales(snapshot.data!);
          }
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Error al cargar datos",
                style: AppStyles.generic.copyWith(color: Colors.red),
              ),
            );
          }
          return const SizedBox(
            height: 170,
            child: Center(
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          );
        },
      ),
    ],
  );
}

Widget seccionPeliculasLista(String titulo, List<Pelicula> peliculas) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [mostrarCategoria(titulo), carruselPeliculasReales(peliculas)],
  );
}

Widget mostrarCategoria(String categoria) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(categoria, style: AppStyles.sectionTitle),
    ),
  );
}

Widget carruselPeliculasReales(List<Pelicula> peliculas) {
  return SizedBox(
    height: 170,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: peliculas.length,
      itemBuilder: (context, index) {
        final peli = peliculas[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              // ClipRRect para redondear las esquinas de la imagen
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/movie_details',
                  arguments: peli,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    peli.posterPath,
                    width: 110,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget datoItem(String titulo, String valor) {
  return Expanded(
    child: Column(
      children: [
        Text(titulo, style: AppStyles.label),
        const SizedBox(height: 4),
        Text(valor, style: AppStyles.dataValue),
      ],
    ),
  );
}

Widget divider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    child: Divider(color: Colors.white24, thickness: 1),
  );
}

Widget divisorVertical() {
  return Container(height: 20, width: 1, color: Colors.white10);
}
