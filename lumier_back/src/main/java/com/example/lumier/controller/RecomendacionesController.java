package com.example.lumier.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lumier.model.PeliculaTMDB;
import com.example.lumier.service.RecomendacionesService;

@RestController
@RequestMapping("/api/recomendaciones")
public class RecomendacionesController {

    @Autowired
    private RecomendacionesService recomendacionesService;

    @GetMapping("/{idUsuario}")
    public ResponseEntity<List<PeliculaTMDB>> obtenerRecomendaciones(
            @PathVariable Integer idUsuario) {
        return ResponseEntity.ok(recomendacionesService.recomendar(idUsuario));
    }
}
