package com.example.lumier.repository;

import java.util.Map;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.lumier.model.Usuario;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    boolean existsByNombreUsuario(String nombreUsuario);

    boolean existsByEmail(String email);

    Optional<Usuario> findByEmail(String email);

    @Query(value = "SELECT u.nombre, u.apellidos, u.nombre_usuario, u.url_avatar, u.biografia, u.fecha_registro, " +
            "(SELECT COUNT(*) FROM interacciones WHERE id_usuario = :id AND tipo_accion = 'VISTA') as total_vistas, " +
            "(SELECT COUNT(*) FROM interacciones WHERE id_usuario = :id AND tipo_accion = 'FAVORITA') as total_favoritos "
            +
            "FROM usuarios u WHERE u.id = :id", nativeQuery = true)
    Map<String, Object> getPerfilStats(@Param("id") Integer id);

}
