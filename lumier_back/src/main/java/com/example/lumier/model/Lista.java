package com.example.lumier.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Listas")
@Data
@NoArgsConstructor
public class Lista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // Mantenemos el ID del usuario como hiciste en Interaccion
    @Column(name = "id_usuario", nullable = false)
    private Integer idUsuario;

    @Column(name = "nombre_lista")
    private String nombreLista;

    @Column(columnDefinition = "Text")
    private String descripcion;

    @Column(name = "fecha_creacion", insertable = false, updatable = false)
    private LocalDateTime fechaCreacion;
    
    @ManyToMany
    @JoinTable(name = "Contenidos_Listas", joinColumns = @JoinColumn(name = "id_lista"), inverseJoinColumns = @JoinColumn(name = "id_contenido"))
    private List<Contenido> contenidos = new ArrayList<>();
}