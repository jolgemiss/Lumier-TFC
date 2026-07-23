package com.example.lumier.repository;

import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.example.lumier.model.Interaccion;
import com.example.lumier.model.PeliculaTMDB;

@Repository
public interface InteraccionRepository extends JpaRepository<Interaccion, Integer> {

        @Query(value = "SELECT COUNT(*) FROM interacciones WHERE id_usuario = :idUsuario AND id_contenido = :idContenido AND tipo_accion = :tipoAccion", nativeQuery = true)
        int existsInteraction(@Param("idUsuario") Integer idUsuario,
                        @Param("idContenido") Long idContenido,
                        @Param("tipoAccion") String tipoAccion);

        @Modifying
        @Transactional
        @Query(value = "INSERT INTO interacciones (id_usuario, id_contenido, tipo_accion) VALUES (:idUsuario, :idContenido, :tipoAccion)", nativeQuery = true)
        void guardarInteraccion(@Param("idUsuario") Integer idUsuario,
                        @Param("idContenido") Long idContenido,
                        @Param("tipoAccion") String tipoAccion);

        @Modifying
        @Transactional
        @Query(value = "DELETE FROM interacciones WHERE id_usuario = :idUsuario AND id_contenido = :idContenido AND tipo_accion = :tipoAccion", nativeQuery = true)
        void eliminarInteraccion(@Param("idUsuario") Integer idUsuario,
                        @Param("idContenido") Long idContenido,
                        @Param("tipoAccion") String tipoAccion);

        @Query(value = """
                        SELECT i.id_contenido FROM interacciones i
                        WHERE i.id_usuario = :idUsuario AND i.tipo_accion = 'FAVORITA'
                        """, nativeQuery = true)
        List<Integer> findFavoritosByUsuario(@Param("idUsuario") Integer idUsuario);

        @Query(value = "SELECT * FROM interacciones WHERE id_usuario = :idUsuario", nativeQuery = true)
        List<Interaccion> findAllByUsuario(@Param("idUsuario") Integer idUsuario);

}