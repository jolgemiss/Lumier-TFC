# Lumier 🎬

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![TMDB](https://img.shields.io/badge/TMDB%20API-01D277?style=for-the-badge&logo=themoviedatabase&logoColor=white)

Lumier es una aplicación de catálogo y recomendación de películas. Combina datos de [TMDB](https://www.themoviedb.org/) con un backend propio que gestiona usuarios, listas personalizadas, reseñas y recomendaciones.

El proyecto está dividido en dos partes independientes dentro de este mismo repositorio:

- **`lumier_back/`** — API REST en Spring Boot (Java).
- **`lumier_front/`** — App móvil en Flutter.

## Funcionalidades

- Registro e inicio de sesión de usuarios (contraseñas hasheadas con BCrypt).
- Catálogo de películas obtenido de TMDB: destacadas, mejor valoradas, por género, superhéroes, búsqueda...
- Ficha de película con reseñas de usuarios.
- Listas personalizadas.
- Recomendaciones personalizadas por usuario.
- Perfil de usuario con biografía editable y estadísticas (total de vistas / favoritos).

## Stack técnico

- **Frontend:** Flutter / Dart
- **Backend:** Spring Boot 4, Spring Data JPA, Spring Security
- **Base de datos:** MySQL
- **API externa:** [TMDB API](https://www.themoviedb.org/settings/api)


## Capturas de pantalla

<table>
  <tr>
    <td align="center"><img src="docs/screenshots/home.png" width="200"/><br/>Inicio</td>
    <td align="center"><img src="docs/screenshots/details.png" width="200"/><br/>Ficha de película</td>
    <td align="center"><img src="docs/screenshots/search.png" width="200"/><br/>Búsqueda</td>
    <td align="center"><img src="docs/screenshots/reviews.png" width="200"/><br/>Publicar reseña</td>
    <td align="center"><img src="docs/screenshots/profile.png" width="200"/><br/>Perfil</td>
  </tr>
</table>

## Puesta en marcha

### Requisitos previos

- JDK 25
- MySQL corriendo en local (o accesible por red)
- Flutter SDK
- Un emulador Android/iOS configurado, o un dispositivo físico
- Una API key de TMDB ([solicítala aquí](https://www.themoviedb.org/settings/api), es gratuita)

### 1. Backend (`lumier_back`)

1. Crea la base de datos (vacía) en MySQL:
   ```sql
   CREATE DATABASE LumierDB;
   ```
   No hace falta crear las tablas a mano: al arrancar el backend (paso siguiente), Hibernate lee las entidades JPA del proyecto y crea automáticamente todas las tablas dentro de `LumierDB`. Si quieres ver esa estructura sin bucear en el código Java, está documentada en [`lumier_back/docs/schema.sql`](lumier_back/docs/schema.sql).
2. Copia el fichero de ejemplo y rellena tus datos:
   ```bash
   cd lumier_back/src/main/resources
   cp application.properties.example application.properties
   ```
   Edita `application.properties` con tu usuario/contraseña de MySQL y tu API key de TMDB.

3. Arranca el servidor:
   ```bash
   cd lumier_back
   ./mvnw spring-boot:run
   ```
   El backend queda escuchando en `http://localhost:8080`. Las tablas se crean automáticamente al arrancar (`spring.jpa.hibernate.ddl-auto=update`).

### 2. Frontend (`lumier_front`)

```bash
cd lumier_front
flutter pub get
flutter run
```

Con el emulador Android ya abierto, `flutter run` lo detecta automáticamente. Puedes elegir un dispositivo concreto con `flutter run -d <device_id>` (usa `flutter devices` para listarlos).

> **Nota sobre la URL del backend:** el frontend apunta a `http://10.0.2.2:8080`, que es la dirección especial con la que el **emulador de Android** accede al `localhost` de tu máquina anfitriona. Si pruebas en el **simulador de iOS** usa `localhost:8080` directamente; si pruebas en un **dispositivo físico**, usa la IP local de tu PC en la red (por ejemplo `192.168.1.x:8080`) y asegúrate de que el firewall permite la conexión. Estas URLs están definidas en `lib/services/*.dart`.

---

## Estructura del backend

```
lumier_back/src/main/java/com/example/lumier/
├── controller/     # Endpoints REST
├── service/        # Lógica de negocio (TMDB, recomendaciones)
├── repository/      # Acceso a datos (Spring Data JPA)
├── model/          # Entidades JPA
├── DTO/            # Objetos de transferencia de datos
└── config/         # Configuración de seguridad
```

### Endpoints principales

| Método | Ruta | Descripción |
|---|---|---|
| `POST` | `/api/usuarios/registro` | Registro de usuario |
| `POST` | `/api/usuarios/login` | Inicio de sesión |
| `GET` | `/api/usuarios/perfil/{id}` | Perfil y estadísticas de usuario |
| `PUT` | `/api/usuarios/biografia/{id}` | Actualizar biografía |
| `GET` | `/api/movies/lista/{endpoint}` | Listado de películas (top rated, populares...) |
| `GET` | `/api/movies/genero/{idGenero}` | Películas por género |
| `GET` | `/api/movies/buscar` | Búsqueda de películas |
| `POST` | `/api/movies/resena` | Publicar una reseña |
| `GET` | `/api/movies/resenas/{tmdbId}` | Reseñas de una película |
| `GET` | `/api/recomendaciones/{idUsuario}` | Recomendaciones personalizadas |
| `POST` | `/api/listas/crear` | Crear una lista |
| `POST` | `/api/listas/agregarPelicula` | Añadir película a una lista |
| `POST` | `/interacciones/toggle` | Marcar/desmarcar favorito o vista |

## Estructura del frontend

```
lumier_front/lib/
├── pages/      # Pantallas (welcome, login, register, home, movie_details, user_profile)
├── services/   # Llamadas HTTP al backend
├── models/     # Modelos de datos
├── widgets/    # Componentes reutilizables
└── utils/      # Estilos y utilidades
```

---

## Notas de desarrollo

Este proyecto ha sido desarrollado como Trabajo de Fin de Ciclo (TFC) para el grado de Desarrollo de Aplicaciones Multiplataforma (DAM).

Debido a los plazos de entrega del curso y a la necesidad académica de demostrar conocimientos en una amplia variedad de metodologías de trabajo, el desarrollo se ha centrado en abarcar un abanico diverso de funciones (integración de backend, frontend, bases de datos, manejo de datos, consumo de APIs externas...). Por este motivo, es posible que algunas funcionalidades básicas o de gestión de errores detallada no estén implementadas por completo, priorizando la variedad técnica sobre la exhaustividad de cada módulo.

