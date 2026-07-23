package com.example.lumier.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lumier.DTO.ResenaDTO;
import com.example.lumier.model.Contenido;
import com.example.lumier.model.PeliculaTMDB;
import com.example.lumier.model.Resena;
import com.example.lumier.model.Usuario;
import com.example.lumier.repository.ContenidoRepository;
import com.example.lumier.repository.ResenaRepository;
import com.example.lumier.repository.UsuarioRepository;
import com.example.lumier.service.PeliculaService;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/api/movies")
@CrossOrigin(origins = "*")
public class PeliculaController {

    @Autowired
    private PeliculaService peliculaService;

    @Autowired
    private ContenidoRepository contenidoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private ResenaRepository resenaRepository;

    @GetMapping("/{id}")
    public ResponseEntity<PeliculaTMDB> getMovie(@PathVariable Long id) {
        PeliculaTMDB pelicula = peliculaService.obtenerDetallesPelicula(id);
        return ResponseEntity.ok(pelicula);
    }

    @GetMapping("/lista/{endpoint}")
    public ResponseEntity<List<PeliculaTMDB>> getCategoryMovies(@PathVariable String endpoint) {
        // Llamamos al método del service que devuelve la lista filtrada
        return ResponseEntity.ok(peliculaService.obtenerPeliculasPorCategoria(endpoint));
    }

    @GetMapping("/genero/{idGenero}")
    public ResponseEntity<List<PeliculaTMDB>> getMoviesByGenre(@PathVariable int idGenero) {
        return ResponseEntity.ok(peliculaService.obtenerPeliculasPorGenero(idGenero));
    }

    @GetMapping("/superheroes")
    public ResponseEntity<List<PeliculaTMDB>> getSuperheroes() {
        return ResponseEntity.ok(peliculaService.obtenerSuperheroes());
    }

    @GetMapping("/{id}/logo")
    public ResponseEntity<String> getLogo(@PathVariable Long id) {
        String logoPath = peliculaService.obtenerLogoPelicula(id);
        if (logoPath != null) {
            return ResponseEntity.ok(logoPath); // Devuelve solo el path del logo, no la URL completa
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<PeliculaTMDB>> buscarPeliculas(@RequestParam String query) {
        return ResponseEntity.ok(peliculaService.buscarPeliculas(query));
    }

    @PostMapping("/resena")
    public ResponseEntity<?> guardarResena(@RequestBody ResenaDTO dto) {
        try {
            // 1. Buscar o crear la película
            Contenido contenido = contenidoRepository.findByTmdbId(dto.getTmdbId())
                    .orElseGet(() -> {
                        Contenido nuevaPeli = new Contenido();
                        nuevaPeli.setTmdbId(dto.getTmdbId());
                        nuevaPeli.setTitulo(dto.getTituloPelicula());
                        nuevaPeli.setUrlPoster(dto.getUrlPoster());
                        return contenidoRepository.save(nuevaPeli);
                    });

            // 2. Buscar el usuario
            Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                    .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

            // 3. Buscar reseña existente del usuario para esa película, o preparar una
            // nueva
            Resena resena = resenaRepository.findByUsuarioAndContenido(usuario, contenido)
                    .orElse(new Resena());

            boolean esNueva = resena.getId() == null; // evaluar ANTES del save

            // 4. Asignar campos (upsert)
            resena.setComentario(dto.getComentario());
            resena.setPuntuacion(dto.getPuntuacion());
            resena.setContenido(contenido);
            resena.setUsuario(usuario);
            resena.setFechaPublicacion(LocalDateTime.now());
            resenaRepository.save(resena);

            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", esNueva ? "Reseña publicada" : "Reseña actualizada"));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al publicar: " + e.getMessage());
        }
    }

    @GetMapping("/resenas/{tmdbId}")
    public ResponseEntity<List<Resena>> obtenerResenasPorPelicula(@PathVariable int tmdbId) {
        List<Resena> resenas = resenaRepository.findByContenidoTmdbIdOrderByFechaPublicacionDesc(tmdbId);
        return ResponseEntity.ok(resenas);
    }

}
