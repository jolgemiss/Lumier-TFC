package com.example.lumier.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lumier.DTO.InteraccionRequestDTO;
import com.example.lumier.model.Contenido;
import com.example.lumier.repository.ContenidoRepository;
import com.example.lumier.repository.InteraccionRepository;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/interacciones")
public class InteraccionController {

        @Autowired
        private InteraccionRepository interaccionRepository;

        @Autowired
        private ContenidoRepository contenidoRepository;

        @PostMapping("/toggle")
        public ResponseEntity<?> toggleInteraccion(@RequestBody InteraccionRequestDTO request) {
                try {
                        // 1. Buscar o crear la película en la DB usando JPA
                        Contenido contenido = contenidoRepository.findByTmdbId(request.getTmdbId())
                                        .orElseGet(() -> {
                                                Contenido nuevaPeli = new Contenido();
                                                nuevaPeli.setTmdbId(request.getTmdbId());
                                                nuevaPeli.setTitulo(request.getTituloPelicula());
                                                nuevaPeli.setUrlPoster(request.getUrlPoster());
                                                return contenidoRepository.save(nuevaPeli);
                                        });

                        // 2. Comprobar si ya existe la interacción exacta que el usuario ha pulsado
                        int existeInteraccion = interaccionRepository.existsInteraction(
                                        request.getIdUsuario(),
                                        contenido.getId(),
                                        request.getTipoAccion());

                        if (existeInteraccion > 0) {
                                // Si ya existía, el usuario la está desmarcando. Simplemente la borramos.
                                interaccionRepository.eliminarInteraccion(
                                                request.getIdUsuario(),
                                                contenido.getId(),
                                                request.getTipoAccion());

                                return ResponseEntity.ok(Map.of(
                                                "status", "eliminado",
                                                "mensaje", "Interacción eliminada correctamente"));
                        } else {
                                // REGLA DE EXCLUSIVIDAD: Calcular la acción contraria
                                // Si la actual es 'VISTA', la contraria es 'FAVORITA' (y viceversa)
                                String accionContraria = request.getTipoAccion().equals("VISTA") ? "FAVORITA" : "VISTA";

                                // Eliminamos la interacción contraria de la base de datos si existía
                                interaccionRepository.eliminarInteraccion(
                                                request.getIdUsuario(),
                                                contenido.getId(),
                                                accionContraria);

                                interaccionRepository.guardarInteraccion(
                                                request.getIdUsuario(),
                                                contenido.getId(),
                                                request.getTipoAccion());

                                return ResponseEntity.ok(Map.of(
                                                "status", "guardado",
                                                "mensaje",
                                                "Interacción guardada correctamente. Se eliminó la acción contraria ("
                                                                + accionContraria + ")."));
                        }

                } catch (Exception e) {
                        return ResponseEntity.status(500)
                                        .body(Map.of("error", "Error en el servidor: " + e.getMessage()));
                }
        }

}
