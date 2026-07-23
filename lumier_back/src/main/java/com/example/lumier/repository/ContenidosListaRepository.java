package com.example.lumier.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.lumier.model.Contenido;
import com.example.lumier.model.Contenidos_Listas;
import com.example.lumier.model.Lista;

public interface ContenidosListaRepository extends JpaRepository<Contenidos_Listas, Integer> {

    boolean existsByListaAndContenido(Lista lista, Contenido contenido);

}
