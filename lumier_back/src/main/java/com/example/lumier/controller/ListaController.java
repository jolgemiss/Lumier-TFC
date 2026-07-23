package com.example.lumier.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lumier.DTO.AgregarContenidoListaDTO;
import com.example.lumier.DTO.ListaDTO;
import com.example.lumier.model.Contenido;
import com.example.lumier.model.Contenidos_Listas;
import com.example.lumier.model.Lista;
import com.example.lumier.model.PeliculaTMDB;
import com.example.lumier.repository.ContenidoRepository;
import com.example.lumier.repository.ContenidosListaRepository;
import com.example.lumier.repository.ListaRepository;
import com.example.lumier.service.PeliculaService;

@RestController
@RequestMapping("/api/listas")
public class ListaController {

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ContenidoRepository contenidoRepository;

    @Autowired
    private ContenidosListaRepository contenidosListaRepository;

    @Autowired
    private PeliculaService peliculaService;

    @PostMapping("/crear")
    public ResponseEntity<?> crearLista(@RequestBody ListaDTO request) {
        try {
            Lista nuevaLista = new Lista();
            nuevaLista.setIdUsuario(request.getIdUsuario());
            nuevaLista.setNombreLista(request.getNombreLista());
            nuevaLista.setDescripcion(request.getDescripcion());

            listaRepository.save(nuevaLista);

            return ResponseEntity.ok(Map.of("mensaje", "Lista creada con éxito"));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Error al crear la lista: " + e.getMessage()));
        }
    }

    @GetMapping("/{idUsuario}")
    public ResponseEntity<?> obtenerListas(@PathVariable Integer idUsuario) {
        return ResponseEntity.ok(listaRepository.findByIdUsuario(idUsuario));
    }

    @PostMapping("/agregarPelicula")
    public ResponseEntity<?> insertarPeliculaLista(@RequestBody AgregarContenidoListaDTO contenidoLista) {
        try {
            Contenido contenido = contenidoRepository.findByTmdbId(contenidoLista.getTmdbId())
                    .orElseGet(() -> {
                        Contenido nuevaPeli = new Contenido();
                        nuevaPeli.setTmdbId(contenidoLista.getTmdbId());
                        nuevaPeli.setTitulo(contenidoLista.getTitulo());
                        nuevaPeli.setUrlPoster(contenidoLista.getUrlPoster());
                        return contenidoRepository.save(nuevaPeli);
                    });

            Lista lista = listaRepository.getReferenceById(contenidoLista.getIdLista());

            if (contenidosListaRepository.existsByListaAndContenido(lista, contenido)) {
                return ResponseEntity.badRequest().body("La película ya está en la lista");
            }

            Contenidos_Listas nuevaRelacion = new Contenidos_Listas();
            nuevaRelacion.setLista(lista);
            nuevaRelacion.setContenido(contenido);
            contenidosListaRepository.save(nuevaRelacion);

            return ResponseEntity.ok("Película añadida con éxito");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al insertar la película");
        }
    }

    @GetMapping("/{listaId}/peliculas")
    public ResponseEntity<?> getPeliculasDeLista(@PathVariable Integer listaId) {

        Lista lista = listaRepository.findById(listaId).orElse(null);
        if (lista == null) {
            return ResponseEntity.notFound().build();
        }

        List<Contenido> contenidos = lista.getContenidos();
        List<PeliculaTMDB> peliculas = contenidos.stream()
                .map((Contenido c) -> peliculaService.obtenerDetallesPelicula(c.getTmdbId().longValue()))
                .collect(Collectors.toList());

        return ResponseEntity.ok(peliculas);
    }
}