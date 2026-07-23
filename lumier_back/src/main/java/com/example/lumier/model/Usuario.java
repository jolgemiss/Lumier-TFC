package com.example.lumier.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "usuarios")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;
    private String apellidos;
    @Column(name = "nombre_usuario")
    private String nombreUsuario;
    private String email;

    private String contrasena;

    @Column(name = "url_avatar")
    private String urlAvatar;

    @Column(nullable = true)
    private String biografia;

    @Column(name = "fecha_registro", insertable = false, updatable = false)
private LocalDateTime fechaRegistro;

}
