package com.example.lumier.repository;

import com.example.lumier.model.Contenido;

import jakarta.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface ContenidoRepository extends JpaRepository<Contenido, Long> {

    Optional<Contenido> findByTmdbId(Integer tmdbId);

    Optional<Contenido> findById(Integer Id);

    Optional<Contenido> findByTitulo(String titulo);

    @Query(value = "SELECT COUNT(*) FROM contenidos WHERE id = :idContenido", nativeQuery = true)
    int existsContenido(@Param("idContenido") Integer idContenido);

    @Modifying
    @Transactional
    @Query(value = "INSERT INTO contenidos (id) VALUES (:idContenido)", nativeQuery = true)
    void guardarContenidoBase(@Param("idContenido") Integer idContenido);
}