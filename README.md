# Presto - Sistema de Gestión de Préstamos Bibliotecarios

Presto es una aplicación móvil y de escritorio construida con **Flutter**, diseñada para modernizar y optimizar los procesos de préstamo y devolución de libros en bibliotecas modernas o escolares. El nombre "Presto" evoca rapidez y facilidad, reflejando el objetivo principal: hacer que el proceso de tomar o devolver un libro sea instantáneo y sin fricciones, tanto para los bibliotecarios como para los usuarios.

---

## Objetivos principales

- **Digitalización de procesos:** reemplazar los registros en papel o sistemas obsoletos por una interfaz digital, intuitiva y centralizada.
- **Acceso remoto:** permitir a los usuarios consultar el catálogo, reservar libros y ver el estado de sus préstamos desde cualquier lugar.
- **Automatización:** reducir la carga administrativa de los bibliotecarios mediante alertas automáticas de devoluciones vencidas y cálculo de multas.
- **Escalabilidad:** al estar hecho en Flutter, la aplicación es multiplataforma (iOS, Android, Web, Windows, macOS, Linux), lo que permite desplegar el sistema en diferentes dispositivos con una sola base de código.

---

## Estado actual del proyecto

Este proyecto está en desarrollo activo. Actualmente incluye:

- [x] Pantalla de inicio con splash screen personalizado
- [x] Splash screen compatible con Android 12+ (`android_12`)
- [x] Inicio de sesión con validación contra base de datos (SQLite)
- [x] Registro de usuarios persistente con correo único y contraseña hasheada (SHA-256)
- [x] Flujo de autenticación: Login → Registro → Login → Home
- [x] Pantalla principal (Home) con bienvenida personalizada (nombre de usuario), perfil y sección de préstamos
- [x] Menú lateral de navegación en el Home (Drawer) hacia Nuevo libro y Registro de préstamos
- [x] Barra superior reutilizable (`BarraSuperior`) usada en varias pantallas
- [x] Registro de préstamos con fecha de devolución automática (15 días)
- [x] Pantalla "Nuevo libro" con validación de duplicados y campos obligatorios
- [x] Catálogo de libros reactivo (`books` ValueNotifier) que se actualiza al agregar un libro
- [x] Catálogo de libros con búsqueda en tiempo real y sugerencias por título/autor
- [x] Buscador de libros como layout reutilizable (`SearchBooksView`)
- [x] Libros guardados en SQLite (tabla `libros`): crear y consultar
- [x] Portada de los libros con cámara o galería (`SelectorImagen`, `PortadaLibro`)
- [ ] Autenticación real (backend / base de datos)
- [ ] Persistencia de préstamos (usuarios y libros ya se guardan en SQLite)
- [ ] Gestión de préstamos y devoluciones
- [ ] Panel de administración para bibliotecarios

---

## Tecnologías utilizadas

- **[Flutter](https://flutter.dev/)** — framework de UI multiplataforma
- **Dart** — lenguaje de programación
- **[flutter_native_splash](https://pub.dev/packages/flutter_native_splash)** — pantalla de carga nativa personalizada
- **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)** — generación de íconos de aplicación
- **[sqflite](https://pub.dev/packages/sqflite)** — base de datos SQLite local (usuarios y libros)
- **[path](https://pub.dev/packages/path)** — rutas de archivos para la base de datos
- **[image_picker](https://pub.dev/packages/image_picker)** — cámara y galería para la portada de los libros
- **[path_provider](https://pub.dev/packages/path_provider)** — carpeta de la app donde se guardan las portadas
- **[crypto](https://pub.dev/packages/crypto)** — hashing SHA-256 de contraseñas

---

## Estructura del proyecto

```
lib/
├── core/
│   └── database/
│       └── database_helper.dart  # Singleton SQLite (tablas users y libros)
├── layouts/
│   ├── barra_superior.dart      # AppBar reutilizable con botón de volver
│   ├── menu_lateral.dart        # Drawer de navegación del Home
│   ├── portada_libro.dart       # Muestra la portada de un libro (o un ícono si no tiene)
│   ├── presto_title.dart        # Encabezado con logo y nombre de la app
│   ├── search_books_view.dart   # Buscador reutilizable con catálogo y sugerencias
│   └── selector_imagen.dart     # Elige la portada con cámara o galería
├── models_books/
│   ├── book.dart                # Modelo Book (categoría, fecha, imagen) + lista reactiva books
│   ├── loan.dart                # Modelo de préstamo (Loan) con cálculo de fecha de devolución
│   └── user.dart                # Modelo User (id, name, email, passwordHash)
├── services/
│   ├── auth_service.dart        # Registro e inicio de sesión contra SQLite (hash SHA-256)
│   └── libro_service.dart       # Guarda (insertarLibro) y consulta (obtenerLibros) libros en SQLite
├── views/
│   ├── login_screen.dart        # Pantalla de entrada: degradado + formulario de login
│   ├── home_page.dart           # Pantalla principal: bienvenida, préstamos, buscador, Drawer
│   ├── login_page.dart          # Formulario de inicio de sesión (valida contra BD)
│   ├── registration_page.dart   # Pantalla de registro de usuario (con correo)
│   ├── loan_registration.dart   # Registro de préstamos con devolución automática a 15 días
│   └── new_book.dart            # Pantalla para agregar un nuevo libro
└── main.dart                    # Punto de entrada de la app

assets/
└── images/                      # Logo, splash screen y recursos gráficos
```

---

## Cómo ejecutar el proyecto

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (versión compatible con Dart `^3.13.2`)
- Un editor como VS Code o Android Studio con el plugin de Flutter
- Un emulador, dispositivo físico, o navegador (para la versión web)

### Pasos

1. Clona el repositorio:
   ```bash
   git clone https://github.com/Vssmxlls/Presto.git
   cd Presto
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Verifica que todo esté en orden:
   ```bash
   flutter doctor
   ```

4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

   Para ejecutar en una plataforma específica:
   ```bash
   flutter run -d chrome    # Web
   flutter run -d windows   # Windows
   flutter run -d macos     # macOS
   ```

### Notas importantes (después de hacer `git pull`)

- Ejecuta `flutter pub get`: se agregaron `image_picker` y `path_provider`.
- La base de datos está en la **versión 3** (usuarios y libros con portada). Se actualiza sola al abrir la app: no hace falta desinstalarla ni se pierden datos.
- **Prueba la app en un teléfono Android.** SQLite (`sqflite`) y la cámara no funcionan en el navegador.
- Si la compilación en Android falla con `this and base files have different roots`, el proyecto y la caché de paquetes de Flutter están en discos distintos. Solución: agregar la línea `kotlin.incremental=false` al archivo `gradle.properties` global del usuario (en Windows: `C:\Users\<usuario>\.gradle\gradle.properties`). No hay que tocar el proyecto.

---

## Configuración de recursos nativos

Para regenerar el splash screen o los íconos tras modificar `pubspec.yaml`:

```bash
flutter pub run flutter_native_splash:create   # Splash screen
dart run flutter_launcher_icons:generate       # Íconos de app
```

---

## Funcionalidades

### Autenticación (backend local)
Registro e inicio de sesión contra una base de datos SQLite local. Las contraseñas se almacenan hasheadas con SHA-256 (paquete `crypto`). El correo debe ser único; el login acepta nombre de usuario o correo.
Splash nativo personalizado con soporte para Android 12+ mediante la sección `android_12` en el `pubspec.yaml`.

### Pantalla principal (Home)
Bienvenida con el nombre del usuario (pasado desde el login), avatar de perfil, menú lateral (Drawer), sección de préstamos (con datos de ejemplo), botón para registrar préstamos y el buscador de libros integrado como layout reutilizable.

### Menú lateral (Drawer)
Menú deslizable que permite ir a "Inicio", "Nuevo libro" y "Registro de préstamos" desde el Home.

### Barra superior reutilizable
`BarraSuperior` (PreferredSizeWidget) con botón de volver y título centrado, usada en las pantallas de Registro, Nuevo libro y otras, evitando duplicar el mismo AppBar.

### Registro de préstamos
Permite registrar un préstamo asignando un usuario y un libro del catálogo. La fecha de devolución se calcula automáticamente a **15 días** del préstamo, se muestra el histórico de préstamos registrados y se sincroniza con la sección "Mis préstamos" del Home.

### Nuevo libro
Formulario para agregar un libro al catálogo (nombre, fecha de publicación con selector de calendario, categoría desplegable, autor). Valida duplicados por título+autor, longitud mínima y que el autor no contenga números. Permite agregar una portada opcional con la cámara o la galería. Al guardar, lo registra en SQLite con `LibroService.insertarLibro`, actualiza la lista reactiva `books` y limpia el formulario.

### Libros en SQLite
Los libros se guardan en la tabla `libros` (id, titulo, autor, categoria, fecha_publicacion, imagen). `LibroService` tiene `insertarLibro` (crear) y `obtenerLibros` (consultar). Al abrir la app, `main.dart` llama a `cargarLibros()`, que llena la lista `books` desde la base de datos; el catálogo, el buscador y el desplegable de préstamos leen esa lista. La primera vez se guardan 10 libros de ejemplo.

Para agregar **editar** y **eliminar** libros: crear en `LibroService` métodos con `db.update` y `db.delete` usando el `id` del `Book` y volver a llamar a `cargarLibros()`. Al eliminar, conviene borrar también el archivo de la portada.

### Portada con cámara o galería
`SelectorImagen` muestra el botón "Agregar portada" con las opciones "Tomar foto" y "Elegir de la galería" (`image_picker`). La imagen se copia a la carpeta de la app y en SQLite solo se guarda su ruta. `PortadaLibro` la muestra en el catálogo y en los resultados de búsqueda (o un ícono si el libro no tiene imagen). Si el usuario niega el permiso de la cámara, la app avisa y sugiere la galería; el permiso está declarado en `android/app/src/main/AndroidManifest.xml`. `SelectorImagen` es reutilizable (por ejemplo, en una pantalla de edición): recibe la ruta actual y avisa el cambio con `alCambiar`.

### Inicio de sesión
Formulario con validación de usuario y contraseña, con opción de redirigir al registro si el usuario no tiene cuenta.

### Registro de usuario
Formulario con validación de nombre, correo electrónico, contraseña (mínimo 6 caracteres) y confirmación de contraseña. Al completar el registro, la app vuelve al inicio de sesión para que el usuario ingrese con sus nuevas credenciales.

### Búsqueda de libros
Catálogo de libros con búsqueda en tiempo real y sugerencias por título o autor, usando `SearchDelegate` de Flutter. El buscador es un layout reutilizable (`SearchBooksView`) que muestra el catálogo completo y filtra las coincidencias mientras escribes.

---

## Roadmap

### Backend

- [x] Base de datos local (SQLite) para usuarios y autenticación
- [x] Lógica de autenticación real (validar credenciales contra la base de datos)
- [x] Persistencia de libros en SQLite (crear y consultar)
- [ ] Editar y eliminar libros (Update y Delete)
- [ ] Persistencia de préstamos (hoy en memoria)
- [ ] Lógica de gestión de préstamos y devoluciones
- [x] Servicio del dispositivo: cámara y galería
- [ ] Segundo servicio del dispositivo: notificaciones de devoluciones próximas a vencer

---

## Contribuciones

Este es un proyecto en construcción. Si quieres contribuir:

1. Haz un fork del repositorio
2. Crea una rama para tu funcionalidad (`git checkout -b feature/nueva-funcionalidad`)
3. Haz commit de tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Sube tu rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## Desarrolladores

- **Samuel Arango Cuesta** — [Vssmxlls](https://github.com/Vssmxlls)
- **Harold Diaz** — [hide165-design](https://github.com/hide165-design)
- **Luis Enrique Ruiz Reyes** — [leruizr](https://github.com/leruizr)

---

## Licencia

Este proyecto está bajo la licencia **MIT** — para más detalles, consulta el archivo [LICENSE](LICENSE).

Copyright (c) 2026 **Samuel Arango Cuesta**