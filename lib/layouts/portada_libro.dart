import 'dart:io';

import 'package:flutter/material.dart';

// Muestra la portada de un libro. Si no tiene imagen, muestra el ícono de libro.
// Se usa en el catálogo, en los resultados de búsqueda y en el selector de imagen.
class PortadaLibro extends StatelessWidget {
  // Ruta de la imagen guardada en el teléfono (puede ser null).
  final String? ruta;
  final double ancho;
  final double alto;

  const PortadaLibro({
    super.key,
    required this.ruta,
    this.ancho = 40,
    this.alto = 56,
  });

  @override
  Widget build(BuildContext context) {
    final icono = SizedBox(
      width: ancho,
      height: alto,
      child: Icon(Icons.book, size: ancho * 0.6),
    );

    if (ruta == null) return icono;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(ruta!),
        width: ancho,
        height: alto,
        fit: BoxFit.cover,
        // Si el archivo ya no existe, se muestra el ícono en su lugar.
        errorBuilder: (context, error, stackTrace) => icono,
      ),
    );
  }
}
