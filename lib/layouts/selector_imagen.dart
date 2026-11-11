import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'portada_libro.dart';

// Selector de portada: permite tomar una foto con la cámara o elegir una de la galería.
// Es reutilizable: la pantalla que lo use guarda la ruta y recibe el cambio en alCambiar.
class SelectorImagen extends StatelessWidget {
  // Ruta de la imagen actual (null si todavía no hay).
  final String? rutaImagen;

  // Se llama con la ruta de la imagen nueva cuando el usuario la elige.
  final ValueChanged<String?> alCambiar;

  const SelectorImagen({
    super.key,
    required this.rutaImagen,
    required this.alCambiar,
  });

  // Muestra las dos opciones: cámara o galería.
  Future<void> _elegirOrigen(BuildContext context) async {
    final origen = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (contextoHoja) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(contextoHoja, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(contextoHoja, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (origen == null || !context.mounted) return;
    await _obtenerImagen(context, origen);
  }

  // Abre la cámara o la galería y devuelve la ruta de la imagen elegida.
  Future<void> _obtenerImagen(BuildContext context, ImageSource origen) async {
    final mensajero = ScaffoldMessenger.of(context);
    try {
      final foto = await ImagePicker().pickImage(
        source: origen,
        maxWidth: 800,
        imageQuality: 80,
      );
      if (foto == null) return; // El usuario canceló.
      alCambiar(await _guardarEnCarpetaApp(foto.path));
    } on PlatformException catch (e) {
      // Si el usuario niega el permiso de la cámara, se le sugiere la galería.
      final mensaje = e.code == 'camera_access_denied'
          ? 'Permiso de cámara denegado. Puedes elegir una imagen de la galería.'
          : 'No se pudo obtener la imagen.';
      mensajero.showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (_) {
      mensajero.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la imagen.')),
      );
    }
  }

  // Copia la imagen a la carpeta de la app para que no se borre:
  // las fotos de la cámara se guardan en una carpeta temporal.
  Future<String> _guardarEnCarpetaApp(String rutaOriginal) async {
    final carpeta = await getApplicationDocumentsDirectory();
    final nombre =
        'portada_${DateTime.now().millisecondsSinceEpoch}${p.extension(rutaOriginal)}';
    final copia = await File(rutaOriginal).copy(p.join(carpeta.path, nombre));
    return copia.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PortadaLibro(ruta: rutaImagen, ancho: 120, alto: 170),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.add_a_photo),
          label: Text(rutaImagen == null ? 'Agregar portada' : 'Cambiar portada'),
          onPressed: () => _elegirOrigen(context),
        ),
      ],
    );
  }
}
