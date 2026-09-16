import 'package:flutter/material.dart';

class NewBook extends StatelessWidget {
  const NewBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Ir al inicio',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Nuevo libro"),
        centerTitle: true,
      ),
      body: const Center(child: Text('Contenido principal')),
    );
  }
}
