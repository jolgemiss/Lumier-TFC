import 'package:flutter/material.dart';
import 'package:lumier_front/models/Peliculas.dart';

import '../globales.dart';
import '../models/Lista.dart';
import '../models/UsuarioPerfil.dart';
import '../services/ListaService.dart';
import '../services/UsuarioService.dart';
import '../utils/app_styles.dart';
import '../widgets/movieWidgets.dart';
import '../widgets/userWidgets.dart';

class UserProflie extends StatefulWidget {
  const UserProflie({super.key});

  @override
  State<UserProflie> createState() => UserProflieState();
}

class UserProflieState extends State<UserProflie> {
  // 1. Declarar controladores y servicios aquí (fuera del build)
  final TextEditingController nombreListaController = TextEditingController();
  final TextEditingController descripcionListaController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final listaService = Listaservice();
  final usuarioService = UsuarioService();

  bool estaEditando = false;

  late Future<List<Lista>> listasFuture;

  @override
  void initState() {
    super.initState();
    listasFuture = listaService.obtenerListas(userIdLogueado!);
  }

  void recargarListas() {
    setState(() {
      listasFuture = listaService.obtenerListas(userIdLogueado!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "MI PERFIL",
          style: AppStyles.label.copyWith(
            color: Colors.amber,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/welcome',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<UsuarioPerfil>(
        future: usuarioService.getUser(userIdLogueado!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error al cargar datos",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No se encontró el usuario"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // 1. HEADER: Avatar con anillo decorativo
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.amber,
                    child: Text(
                      user.nombreUsuario[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Nombre y User
                Text(
                  "${user.nombre} ${user.apellidos}",
                  style: AppStyles.dataValue.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "@${user.nombreUsuario.toLowerCase()}",
                  style: AppStyles.label.copyWith(
                    color: Colors.amber,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                // 2. BIOGRAFÍA
                Column(
                  children: [
                    if (estaEditando)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: TextField(
                          controller: bioController,
                          maxLines: 3,
                          maxLength: 100,
                          style: AppStyles.dataValue.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: "Escribe algo sobre ti...",
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: .1),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          user.biografia.isEmpty
                              ? "Aún no hay biografía"
                              : user.biografia,
                          textAlign: TextAlign.center,
                          style: AppStyles.dataValue.copyWith(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (estaEditando)
                      // BOTONES DE GUARDAR Y CANCELAR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                estaEditando = false;
                              });
                            },
                            child: Text(
                              "Cancelar",
                              style: AppStyles.buttonText.copyWith(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await usuarioService.actualizarBiografia(userIdLogueado!, bioController.text);
                                setState(() {
                                  user.biografia = bioController.text;
                                  estaEditando = false;
                                });
                              } catch (e) {
                                snackbarResultado(context, "Error al actualizar la biografía, inténtalo más tarde", Colors.red[600]!);
                                
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Guardar",
                              style: AppStyles.buttonText,
                            ),
                          ),
                        ],
                      )
                    else
                      // BOTÓN DE EDITAR
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            // Metemos el texto actual en el controlador para que no empiece vacío
                            bioController.text = user.biografia;
                            estaEditando = true; // Activamos el modo edición
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.amber,
                        ),
                        label: const Text(
                          "Editar biografía",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),
                divider(),
                // 3. ESTADÍSTICAS (Encapsuladas en una "Card")
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .05), // Fondo sutil
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        datoPerfil(user.totalVistas.toString(), "Vistas"),
                        divisorVertical(),
                        datoPerfil(user.totalFavoritos.toString(), "Favoritas"),
                      ],
                    ),
                  ),
                ),

                divider(),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Align(
                    alignment: Alignment.center, // Alineado a la izquierda
                    child: IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // Color plano translúcido en lugar de degradado
                          color: Colors.white.withValues(alpha: 0.03),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                            width: 1.0,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(
                                    0xFF141414,
                                  ), // Fondo oscuro Lumier
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: Colors.white10,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      const Icon(
                                        Icons.playlist_add_rounded,
                                        color: Colors.amberAccent,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Nueva Lista',
                                        style: AppStyles.label,
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '¿Cómo quieres llamar a tu lista de películas? (Campo obligatorio)',
                                        style: AppStyles.label,
                                      ),
                                      const SizedBox(height: 16),
                                      // Input de texto premium
                                      TextField(
                                        controller: nombreListaController,
                                        autofocus: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'PELIS 2026, MARATÓN...',
                                          hintStyle: AppStyles.dataValue
                                              .copyWith(color: Colors.white24),
                                          filled: true,
                                          fillColor: Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.white10,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.amberAccent,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20),
                                      Text(
                                        'Escribe una descripcion (Campo obligatorio)',
                                        style: AppStyles.label,
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: descripcionListaController,
                                        maxLines: 2,
                                        maxLength: 50,
                                        autofocus: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          hintText:
                                              '¡¡Esta es mi lista de películas favoritas este año!!',
                                          hintStyle: AppStyles.dataValue
                                              .copyWith(color: Colors.white24),
                                          filled: true,
                                          fillColor: Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.white10,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.amberAccent,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    // Botón Cancelar
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'CANCELAR',
                                        style: AppStyles.buttonText.copyWith(
                                          color: Colors.white38,
                                        ),
                                      ),
                                    ),
                                    // Botón Guardar
                                    ElevatedButton(
                                      onPressed: () async {
                                        // 1. Obtener los valores de los controladores
                                        String nombre = nombreListaController
                                            .text
                                            .trim();
                                        String desc = descripcionListaController
                                            .text
                                            .trim();

                                        // 2. Crear el objeto con los datos obtenidos
                                        Lista nuevaLista = Lista(
                                          idUsuario: userIdLogueado!,
                                          nombreLista: nombre,
                                          descripcion: desc,
                                          fechaRegistro: '',
                                        );

                                        // 3. Llamar al servicio (ejecutando la lógica que ya tienes)
                                        try {
                                          await listaService.crearLista(
                                            nuevaLista,
                                          );

                                          // Si no lanza error, cerramos el diálogo y avisamos
                                          Navigator.pop(context);
                                          snackbarResultado(
                                            context,
                                            'Lista creada con éxito',
                                            Colors.green[700]!,
                                          );
                                        } catch (e) {
                                          // Si hubo error, capturamos el fallo
                                          snackbarResultado(
                                            context,
                                            'Error al crear la lista',
                                            Colors.red[700]!,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amberAccent
                                            .withValues(alpha: 0.15),
                                        foregroundColor: Colors.amberAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          side: const BorderSide(
                                            color: Colors.amberAccent,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'CREAR',
                                        style: AppStyles.buttonText.copyWith(
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Colors.amberAccent.withValues(
                            alpha: 0.08,
                          ),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 14,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  color: Colors.amberAccent.withValues(
                                    alpha: 0.8,
                                  ),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'NUEVA LISTA',
                                  style: AppStyles.buttonText.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                FutureBuilder<List<Lista>>(
                  future: listasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Error al cargar las listas',
                          style: TextStyle(color: Colors.red.shade300),
                        ),
                      );
                    }

                    final listas = snapshot.data ?? [];

                    if (listas.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Icon(
                              Icons.playlist_remove,
                              color: Colors.white24,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Aún no tienes listas',
                              style: AppStyles.label.copyWith(
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap:
                          true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: listas.length,
                      itemBuilder: (context, index) {
                        final lista = listas[index];
                        return Card(
                          color: const Color(0xFF141414),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lista.nombreLista,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  lista.descripcion,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.amber,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Creada el: ${lista.fechaRegistro}',
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                divider(),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<List<Pelicula>>(
                                      future: listaService
                                          .obtenerPeliculasDeLista(lista.id!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return carruselPeliculasReales(
                                            snapshot.data!,
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              "Error al cargar datos",
                                              style: AppStyles.generic.copyWith(
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox(
                                          height: 170,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.amber,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
