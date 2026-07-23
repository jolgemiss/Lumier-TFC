package com.example.lumier.repository;

import com.example.lumier.model.Contenido;
import com.example.lumier.model.Resena;
import com.example.lumier.model.Usuario;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ResenaRepository extends JpaRepository<Resena, Long> {

    // Método extra útil: Buscar todas las reseñas de una película específica
    // Spring Boot genera la consulta automáticamente por el nombre del método
    List<Resena> findByContenidoId(Long contenidoId);

    // Método extra útil: Buscar todas las reseñas de un usuario
    List<Resena> findByUsuarioId(Long usuarioId);

    Optional<Resena> findByUsuarioAndContenido(Usuario usuario, Contenido contenido);

    List<Resena> findByContenidoTmdbIdOrderByFechaPublicacionDesc(int tmdbId);

    @Query(value = """
                SELECT r.contenido.id FROM Resena r
                WHERE r.usuario.id = :idUsuario AND r.puntuacion >= 4
            """)
    List<Long> findContenidosBienValoradosByUsuario(@Param("idUsuario") Long idUsuario);
}