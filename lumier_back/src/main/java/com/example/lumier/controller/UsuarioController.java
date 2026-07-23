package com.example.lumier.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.example.lumier.DTO.ActualizarBiografiaDTO;
import com.example.lumier.DTO.UsuarioPerfilDTO;
import com.example.lumier.model.Usuario;
import com.example.lumier.repository.UsuarioRepository;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;
    @Autowired

    private PasswordEncoder passwordEncoder;

    // Endpoint para registrar un nuevo usuario
    @PostMapping("/registro")
    public ResponseEntity<String> registrarUsuario(@RequestBody Usuario usuario) {
        // Verificar si el nombre de usuario o el correo electrónico ya existen
        if (usuarioRepository.existsByNombreUsuario(usuario.getNombreUsuario())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error: El nombre de usuario ya está en uso.");
        }
        // Verificar si el correo electrónico ya existe
        if (usuarioRepository.existsByEmail(usuario.getEmail())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Error: El correo electrónico ya está registrado.");
        }
        usuario.setContrasena(passwordEncoder.encode(usuario.getContrasena()));
        usuarioRepository.save(usuario);

        return ResponseEntity.status(HttpStatus.CREATED).body("Usuario registrado con éxito.");
    }

    /**
     * Autentica a un usuario en el sistema validando sus credenciales de acceso.
     *
     * El método busca al usuario por su correo electrónico y, si existe, contrasta
     * la contraseña proporcionada. Controla de forma segura los escenarios de fallo
     * emitiendo códigos de estado HTTP estandarizados para no comprometer la
     * seguridad.
     *
     * @param usuario Objeto Usuario encapsulado en el cuerpo de la petición
     *                (RequestBody)
     *                que contiene el email y la contraseña a validar.
     * @return Un ResponseEntity que contiene:
     *         - 200 OK: Con los datos completos del usuario autenticado si las
     *         credenciales son válidas.
     *         - 401 Unauthorized: Con un mensaje de error explícito si el correo no
     *         está registrado
     *         o si la contraseña es incorrecta.
     */
    @PostMapping("/login")
    public ResponseEntity<?> loginUsuario(@RequestBody Usuario usuario) {
        System.out.println("Intentando login para: " + usuario.getEmail());

        Usuario usuarioExistente = usuarioRepository.findByEmail(usuario.getEmail()).orElse(null);

        // CASO 1: No existe el usuario
        if (usuarioExistente == null) {
            System.out.println("Resultado: Usuario no encontrado");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED) // Fuerza el código 401
                    .body("Error: El correo electrónico no está registrado.");
        }

        // CASO 2: Contraseña incorrecta
        if (!passwordEncoder.matches(usuario.getContrasena(), usuarioExistente.getContrasena())) {
            System.out.println("Resultado: Contraseña incorrecta");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED) // Fuerza el código 401
                    .body("Error: Contraseña incorrecta.");
        }

        // CASO 3: Éxito total
        usuarioExistente.setContrasena(null);
        System.out.println("Resultado: ÉXITO");
        return ResponseEntity.ok(usuarioExistente);
    }

    @GetMapping("/perfil/{id}")
    public ResponseEntity<UsuarioPerfilDTO> obtenerPerfil(@PathVariable Integer id) {
        Map<String, Object> stats = usuarioRepository.getPerfilStats(id);

        if (stats == null || stats.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        UsuarioPerfilDTO dto = new UsuarioPerfilDTO(
                (String) stats.get("nombre"),
                (String) stats.get("apellidos"),
                (String) stats.get("nombre_usuario"),
                (String) stats.get("url_avatar"),
                (String) stats.get("biografia"),
                stats.get("fecha_registro").toString(), // Convertimos la fecha a String para el DTO
                ((Number) stats.get("total_vistas")).longValue(),
                ((Number) stats.get("total_favoritos")).longValue());

        return ResponseEntity.ok(dto);
    }

    @PutMapping("biografia/{id}")
    public ResponseEntity<?> modificarBiografiaEntity(@PathVariable Long id,
            @RequestBody ActualizarBiografiaDTO biografia) {

        try {
            Usuario usuario = usuarioRepository.findById(id).orElse(null);
            if (usuario == null) {
                return ResponseEntity.notFound().build();
            }

            usuario.setBiografia(biografia.getBiografia());
            usuarioRepository.save(usuario);

            return ResponseEntity.ok().body("Biografía actualizada");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al modificar la biografía");
        }

    }
}
