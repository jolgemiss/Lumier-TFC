package com.example.lumier.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.lumier.model.Lista;

public interface ListaRepository extends JpaRepository<Lista, Integer>{

    List<Lista> findByIdUsuario(Integer idUsuario);
    
}
