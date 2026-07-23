package com.example.lumier.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "interacciones")
@Data
@NoArgsConstructor
public class Interaccion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "id_usuario", nullable = false)
    private Integer idUsuario;

    @Column(name = "id_contenido", nullable = false)
    private Integer idContenido;

    @Column(name = "tipo_accion", nullable = false)
    private String tipoAccion;

    @Column(name = "fecha_interaccion", insertable = false, updatable = false)
    private LocalDateTime fechaInteraccion;
}