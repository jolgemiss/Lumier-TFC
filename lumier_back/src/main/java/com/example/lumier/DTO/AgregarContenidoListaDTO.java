package com.example.lumier.DTO;

import lombok.Data;

@Data
public class AgregarContenidoListaDTO {
    private int idLista;
    private int tmdbId;
    private String titulo;
    private String urlPoster;
}
