package com.example.lumier.service;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lumier.model.Contenido;
import com.example.lumier.model.PeliculaTMDB;
import com.example.lumier.repository.ContenidoRepository;
import com.example.lumier.repository.InteraccionRepository;

@Service
public class RecomendacionesService {

    @Autowired
    private InteraccionRepository interaccionRepository;
    @Autowired
    private ContenidoRepository contenidoRepository;
    @Autowired
    private PeliculaService peliculaService;

    public List<PeliculaTMDB> recomendar(Integer idUsuario) {
        // 1. Obtener tmdbIds de las FAVORITAs del usuario
        List<Integer> idsFavoritos = interaccionRepository.findFavoritosByUsuario(idUsuario);

        if (idsFavoritos.isEmpty()) {
            // Cold start: devolver películas populares
            return peliculaService.obtenerPeliculasPorCategoria("popular");
        }

        // 2. Obtener tmdbIds ya vistos/favoritos para excluirlos
        Set<Integer> yaInteractuados = interaccionRepository
                .findAllByUsuario(idUsuario) // añade este método al repo
                .stream()
                .map(i -> contenidoRepository.findById(i.getIdContenido())
                        .map(Contenido::getTmdbId).orElse(null))
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        // 3. Por cada favorita, pedir recomendaciones a TMDB
        return idsFavoritos.stream()
                .flatMap(idContenido -> {
                    Contenido c = contenidoRepository.findById(idContenido.longValue()).orElse(null);
                    if (c == null)
                        return Stream.empty();
                    return peliculaService.obtenerRecomendacionesTMDB(c.getTmdbId()).stream();
                })
                // 4. Filtrar las ya interactuadas y deduplicar
                .filter(p -> !yaInteractuados.contains(p.getId()))
                .collect(Collectors.toMap(
                        PeliculaTMDB::getId, p -> p, (a, b) -> a)) // dedup por ID
                .values().stream()
                // Aquí obligamos a Java a reconocer que 'p' es una 'PeliculaTMDB'
                .sorted(Comparator.comparingDouble((PeliculaTMDB p) -> {
                    return p.getVoteAverage() != null ? (double) p.getVoteAverage() : 0.0;
                }).reversed())
                .limit(20)
                .collect(Collectors.toList());
    }
}
