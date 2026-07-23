package com.example.lumier.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "resenas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Resena {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT", nullable = true) // Para que el comentario sea largo
    private String comentario;

    @Column(nullable = false)
    private Double puntuacion;

    @Column(name = "fecha_publicacion")
    private LocalDateTime fechaPublicacion;

    // RELACIÓN CON EL CONTENIDO (Película/Serie)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_contenido", nullable = false)
    @JsonBackReference // Evita el bucle infinito Peli -> Reseña -> Peli
    private Contenido contenido;

    // RELACIÓN CON EL USUARIO
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

}