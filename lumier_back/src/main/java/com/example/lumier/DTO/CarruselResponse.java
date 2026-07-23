package com.example.lumier.DTO;

import lombok.Data;
import java.util.List;

import com.example.lumier.model.PeliculaTMDB;

// Esta clase es para mapear la respuesta de la API de TMDb cuando pedimos una lista de películas (popular, top_rated, etc.)
@Data
public class CarruselResponse {
    // Este nombre "results" es obligatorio porque así se llama en el JSON de TMDB
    private List<PeliculaTMDB> results;
}
