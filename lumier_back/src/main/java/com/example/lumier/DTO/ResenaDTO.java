package com.example.lumier.DTO;

import lombok.Data;

@Data
public class ResenaDTO {
    private String comentario;
    private Double puntuacion;
    private Long usuarioId; // El ID del usuario que escribe
    private Integer tmdbId; // El ID de la película en la API (para buscarla en el Back)
    private String tituloPelicula;
    private String urlPoster;
}