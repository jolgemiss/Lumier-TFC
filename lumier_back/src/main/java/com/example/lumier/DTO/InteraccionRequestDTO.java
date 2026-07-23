package com.example.lumier.DTO;

import lombok.Data;

@Data
public class InteraccionRequestDTO {
    private Integer idUsuario;
    private Integer tmdbId;
    private String tipoAccion;
    private String tituloPelicula;
    private String urlPoster;
}