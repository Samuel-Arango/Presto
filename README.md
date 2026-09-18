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
- [x] Inicio de sesión con validación de formulario
- [x] Registro de nuevos usuarios con validación de contraseña y confirmación
- [x] Flujo de autenticación: Login → Registro → Login → Home
- [x] Pantalla principal (Home) con bienvenida, perfil y sección de préstamos
- [x] Botón flotante (+) para agregar libros (en desarrollo)
- [x] Catálogo de libros con búsqueda en tiempo real y sugerencias por título/autor
- [x] Buscador de libros como layout reutilizable (`SearchBooksView`)
- [ ] Autenticación real (backend / base de datos)
- [ ] Persistencia de usuarios y préstamos
- [ ] Gestión de préstamos y devoluciones
- [ ] Panel de administración para bibliotecarios

---

## Tecnologías utilizadas

- **[Flutter](https://flutter.dev/)** — framework de UI multiplataforma
- **Dart** — lenguaje de programación
- **[flutter_native_splash](https://pub.dev/packages/flutter_native_splash)** — pantalla de carga nativa personalizada
- **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)** — generación de íconos de aplicación
- **[animate_do](https://pub.dev/packages/animate_do)** — animaciones de UI

---

## Estructura del proyecto

```
lib/
├── layouts/
│   ├── presto_title.dart       # Encabezado con logo y nombre de la app
│   └── search_books_view.dart  # Buscador reutilizable con catálogo y sugerencias
├── models_books/
│   └── book.dart               # Modelo de datos Book y catálogo de ejemplo
├── views/
│   ├── login_screen.dart       # Pantalla de entrada: degradado + formulario de login
│   ├── home_page.dart          # Pantalla principal: bienvenida, perfil, préstamos y buscador
│   ├── login_page.dart         # Formulario de inicio de sesión
│   └── registration_page.dart  # Pantalla de registro de usuario
└── main.dart                   # Punto de entrada de la app

assets/
└── images/                     # Logo, splash screen y recursos gráficos
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

---

## Configuración de recursos nativos

Para regenerar el splash screen o los íconos tras modificar `pubspec.yaml`:

```bash
flutter pub run flutter_native_splash:create   # Splash screen
dart run flutter_launcher_icons:generate       # Íconos de app
```

---

## Funcionalidades

### Splash screen
Splash nativo personalizado con soporte para Android 12+ mediante la sección `android_12` en el `pubspec.yaml`.

### Pantalla principal (Home)
Bienvenida con el nombre de usuario, avatar de perfil, sección de préstamos (con datos de ejemplo) y el buscador de libros integrado como layout reutilizable.

### Inicio de sesión
Formulario con validación de usuario y contraseña, con opción de redirigir al registro si el usuario no tiene cuenta.

### Registro de usuario
Formulario con validación de nombre, correo electrónico, contraseña (mínimo 6 caracteres) y confirmación de contraseña. Al completar el registro, la app vuelve al inicio de sesión para que el usuario ingrese con sus nuevas credenciales.

### Búsqueda de libros
Catálogo de libros con búsqueda en tiempo real y sugerencias por título o autor, usando `SearchDelegate` de Flutter. El buscador es un layout reutilizable (`SearchBooksView`) que muestra el catálogo completo y filtra las coincidencias mientras escribes.

---

## Roadmap

- [ ] Conectar login y registro a una base de datos (local con SQLite o remota con Firebase/API propia)
- [ ] Implementar lógica de autenticación real (validar credenciales contra la BD)
- [ ] Pantalla para agregar libros (formulario conectado al botón `+`)
- [ ] Agregar gestión de estado (Provider / Riverpod / Bloc)
- [ ] Sistema de préstamos: solicitar, devolver, historial
- [ ] Notificaciones de devoluciones próximas a vencer
- [ ] Panel administrativo para bibliotecarios
- [ ] Tests unitarios y de widgets

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

---

## Licencia

Este proyecto está bajo la licencia **MIT** — para más detalles, consulta el archivo [LICENSE](LICENSE).

Copyright (c) 2026 **Samuel Arango Cuesta**