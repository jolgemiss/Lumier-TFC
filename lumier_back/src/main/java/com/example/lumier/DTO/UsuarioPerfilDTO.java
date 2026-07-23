package com.example.lumier.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UsuarioPerfilDTO {
    private String nombre;
    private String apellidos;
    private String nombreUsuario;
    private String urlAvatar;
    private String biografia;
    private String fechaRegistro;
    private long totalVistas;
    private long totalFavoritos;
}
