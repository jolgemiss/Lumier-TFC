package com.example.lumier.DTO;

import lombok.Data;

@Data
public class ListaDTO {
    private Integer idUsuario;
    private String nombreLista;
    private String descripcion;
    private String fechaRegistro;
}