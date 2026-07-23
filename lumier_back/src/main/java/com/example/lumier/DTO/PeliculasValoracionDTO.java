package com.example.lumier.DTO;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PeliculasValoracionDTO {
    private Long totalVotes;
    private Double averageRating;

    public PeliculasValoracionDTO(Long totalVotes, Double averageRating) {
        this.totalVotes = (totalVotes != null) ? totalVotes : 0L;
        // Redondeamos a un decimal para que Flutter reciba 4.3 y no 4.333333333
        this.averageRating = (averageRating != null)
                ? Math.round(averageRating * 10.0) / 10.0
                : 0.0;
    }
}