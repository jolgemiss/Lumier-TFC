package com.example.lumier.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

@Entity
@Table(name = "Contenidos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Contenido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // ID interno autoincremental (1, 2, 3...)

    @Column(name = "tmdb_id", nullable = false, unique = true)
    private Integer tmdbId; // ID de la API (ej: 24428)

    @Column(nullable = false)
    private String titulo;

    @Column(name = "url_poster", nullable = false)
    private String urlPoster;

    @OneToMany(mappedBy = "contenido", cascade = CascadeType.ALL)
    @JsonManagedReference // Permite ver las reseñas cuando pides la película
    private List<Resena> resenas;

    // Constructor simplificado
    public Contenido(Integer tmdbId, String titulo) {
        this.tmdbId = tmdbId;
        this.titulo = titulo;
    }
}