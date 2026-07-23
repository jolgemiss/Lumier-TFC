-- ============================================================
-- Lumier - Esquema de base de datos
-- ============================================================
-- Este es el script real usado para crear la base de datos del
-- proyecto. Spring Boot también puede generar/actualizar estas
-- mismas tablas solo con arrancar el backend (ver
-- "spring.jpa.hibernate.ddl-auto=update" en application.properties),
-- pero este script sirve para:
--   - Ver la estructura completa de un vistazo sin leer las
--     entidades Java.
--   - Recrear la base de datos manualmente si hace falta.
--
-- ⚠ OJO: el DROP DATABASE de la primera línea borra toda la BD
-- existente (incluidos usuarios y reseñas reales) antes de
-- recrearla. Solo úsalo en un entorno local/de pruebas.
-- ============================================================

-- 1. Limpieza y creación de la base de datos
DROP DATABASE IF EXISTS LumierDB;
CREATE DATABASE LumierDB;
USE LumierDB;

-- 2. Tabla de Usuarios
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellidos VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,  -- hash BCrypt (60 caracteres), nunca texto plano
    url_avatar VARCHAR(255) DEFAULT NULL,
    biografia TEXT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Contenidos (nexo con TMDB para pelis y series)
CREATE TABLE Contenidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tmdb_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    url_poster VARCHAR(255),
    UNIQUE KEY unique_contenido (tmdb_id)
);

-- 4. Tabla de Reseñas
CREATE TABLE Resenas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_contenido INT NOT NULL,
    comentario TEXT NOT NULL,
    puntuacion TINYINT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_contenido) REFERENCES Contenidos(id) ON DELETE CASCADE
);

-- 5. Tabla de Interacciones (favoritos / vistas de un usuario)
CREATE TABLE Interacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_contenido INT NOT NULL,
    tipo_accion ENUM('VISTA', 'FAVORITO') NOT NULL,
    fecha_interaccion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_contenido) REFERENCES Contenidos(id) ON DELETE CASCADE
);

-- 6. Tabla de Listas (agrupaciones creadas por el usuario)
CREATE TABLE Listas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre_lista VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id) ON DELETE CASCADE
);

-- 7. Tabla intermedia: Contenidos_Listas
CREATE TABLE Contenidos_Listas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_lista INT NOT NULL,
    id_contenido INT NOT NULL,
    FOREIGN KEY (id_lista) REFERENCES Listas(id) ON DELETE CASCADE,
    FOREIGN KEY (id_contenido) REFERENCES Contenidos(id) ON DELETE CASCADE,
    UNIQUE(id_lista, id_contenido)
);
