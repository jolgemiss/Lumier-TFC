package com.example.lumier.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPInputStream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.client.ClientHttpResponse;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriUtils;

import com.example.lumier.DTO.CarruselResponse;
import com.example.lumier.model.PeliculaTMDB;

@Service
public class PeliculaService {
    // Aquí podrías agregar métodos para interactuar con la API de películas, como
    // obtener detalles de una película, buscar por título, etc.
    @Value("${tmdb.api.key}")
    private String apiKey;
    private final String apiBaseUrl = "https://api.themoviedb.org/3";

    private RestTemplate restTemplate = new RestTemplate();

    public PeliculaService() {
        this.restTemplate = new RestTemplate();

        this.restTemplate.getInterceptors().add((request, body, execution) -> {
            ClientHttpResponse response = execution.execute(request, body);
            String encoding = response.getHeaders().getFirst(HttpHeaders.CONTENT_ENCODING);
            if ("gzip".equalsIgnoreCase(encoding)) {
                return new GzipClientHttpResponse(response);
            }
            return response;
        });
    }

    private static class GzipClientHttpResponse implements ClientHttpResponse {
        private final ClientHttpResponse delegate;
        private InputStream decompressedStream;

        GzipClientHttpResponse(ClientHttpResponse delegate) {
            this.delegate = delegate;
        }

        @Override
        public InputStream getBody() throws IOException {
            if (decompressedStream == null) {
                decompressedStream = new GZIPInputStream(delegate.getBody());
            }
            return decompressedStream;
        }

        @Override
        public HttpHeaders getHeaders() {
            HttpHeaders headers = new HttpHeaders();
            headers.putAll(delegate.getHeaders());
            headers.remove(HttpHeaders.CONTENT_ENCODING);
            return headers;
        }

        @Override
        public HttpStatusCode getStatusCode() throws IOException {
            return delegate.getStatusCode();
        }

        @Override
        public String getStatusText() throws IOException {
            return delegate.getStatusText();
        }

        @Override
        public void close() {
            delegate.close();
        }
    }

    // Método para obtener detalles de una película por su ID
    public PeliculaTMDB obtenerDetallesPelicula(Long id) {
        String url = String.format("%s/movie/%d?api_key=%s&language=es-ES",
                apiBaseUrl, id, apiKey);

        // Realiza la solicitud GET a la API y mapea la respuesta a un objeto Pelicula
        PeliculaTMDB pelicula = restTemplate.getForObject(url, PeliculaTMDB.class);

        return pelicula;
    }

    // Método para obtener la lista de películas según la categoría (popular,
    // top_rated)
    public List<PeliculaTMDB> obtenerPeliculasPorCategoria(String endpoint) {
        // 'tipo' será "popular", "top_rated" o "now_playing"
        String url = String.format("%s/movie/%s?api_key=%s&language=es-ES",
                apiBaseUrl, endpoint, apiKey);

        CarruselResponse response = restTemplate.getForObject(url, CarruselResponse.class);

        return (response != null) ? response.getResults() : Collections.emptyList();
    }

    // Método corregido: sin la variable 'endpoint' innecesaria
    public List<PeliculaTMDB> obtenerPeliculasPorGenero(int idGenero) {
        // Solo necesitamos 3 marcadores: base, api_key e idGenero
        String url = String.format("%s/discover/movie?api_key=%s&language=es-ES&with_genres=%d&sort_by=popularity.desc",
                apiBaseUrl, apiKey, idGenero);

        CarruselResponse response = restTemplate.getForObject(url, CarruselResponse.class);

        return (response != null) ? response.getResults() : Collections.emptyList();
    }

    public List<PeliculaTMDB> obtenerSuperheroes() {
        String url = "https://api.themoviedb.org/3/discover/movie?api_key=" + apiKey
                + "&with_keywords=9715&language=es-ES&sort_by=popularity.desc";
        CarruselResponse response = restTemplate.getForObject(url, CarruselResponse.class);
        return (response != null) ? response.getResults() : Collections.emptyList();
    }

    public String obtenerLogoPelicula(Long movieId) {
        String url = "https://api.themoviedb.org/3/movie/" + movieId + "/images?api_key=" + apiKey;

        Map<String, Object> respuesta = restTemplate.getForObject(url, Map.class);
        if (respuesta != null && respuesta.containsKey("logos")) {
            List<Map<String, Object>> logos = (List<Map<String, Object>>) respuesta.get("logos");
            if (!logos.isEmpty()) {
                // Buscamos el logo siguiendo el orden de prioridad
                Map<String, Object> logoFinal = logos.stream()
                        .filter(l -> "es".equals(l.get("iso_639_1"))) // 1. Intentar Español
                        .findFirst()
                        .orElseGet(() -> logos.stream()
                                .filter(l -> "en".equals(l.get("iso_639_1"))) // 2. Si no, intentar Inglés
                                .findFirst()
                                .orElse(logos.get(0))); // 3. Si no, el primero que venga (chino, etc.)

                return "https://image.tmdb.org/t/p/w500" + logoFinal.get("file_path");
            }
        }
        return null;
    }

    public List<PeliculaTMDB> obtenerRecomendacionesTMDB(Integer tmdbId) {
        String url = String.format("%s/movie/%d/recommendations?api_key=%s&language=es-ES",
                apiBaseUrl, tmdbId, apiKey);
        CarruselResponse response = restTemplate.getForObject(url, CarruselResponse.class);
        return (response != null) ? response.getResults() : Collections.emptyList();
    }

    public List<PeliculaTMDB> buscarPeliculas(String query) {
        String url = String.format("%s/search/movie?api_key=%s&language=es-ES&query=%s",
                apiBaseUrl, apiKey, UriUtils.encode(query, java.nio.charset.StandardCharsets.UTF_8));
        CarruselResponse response = restTemplate.getForObject(url, CarruselResponse.class);
        return (response != null) ? response.getResults() : Collections.emptyList();
    }

}
