import 'package:flutter/material.dart';

import '../models_books/book.dart';

class NewBook extends StatefulWidget {
  const NewBook({super.key});

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();

  String? _categoria;
  DateTime? _fechapubli;
  int _form = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechapubli ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _fechapubli = picked;
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

    // Valida el formulario, agrega el libro al catálogo, avisa y limpia los campos.
  void _guardarLibro() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _titleController.text.trim(),
        author: _autorController.text.trim(),
        category: _categoria,
        publishedDate: _fechapubli,
      );
      addLibro(book);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Libro "${book.title}" agregado al catálogo')),
      );

      FocusScope.of(context).unfocus();
      _formKey.currentState!.reset();
      setState(() {
        _titleController.clear();
        _dateController.clear();
        _autorController.clear();
        _categoria = null;
        _fechapubli = null;
        _form++;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Ir al inicio',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Nuevo libro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre del libro',
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre del libro';
                  }
                  if (value.trim().length < 2) {
                    return 'Mínimo 2 caracteres';
                  }
                  if (existeLibro(value, _autorController.text)) {
                    return 'Este libro ya está en el catálogo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de publicación',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fecha de publicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                key: ValueKey(_form),
                initialValue: _categoria,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.list),
                ),
                items: const [
                  DropdownMenuItem(value: 'Ficción', child: Text('Ficción')),
                  DropdownMenuItem(value: 'Medicina', child: Text('Medicina')),
                  DropdownMenuItem(value: 'Ciencia', child: Text('Ciencia')),
                  DropdownMenuItem(
                    value: 'Agronomia',
                    child: Text('Agronomia'),
                  ),
                  DropdownMenuItem(
                    value: 'Programacion',
                    child: Text('Programacion'),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _categoria = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _autorController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre del autor',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre del autor';
                  }
                  if (value.trim().length < 3) {
                    return 'Mínimo 3 caracteres';
                  }
                  if (RegExp(r'\d').hasMatch(value)) {
                    return 'El nombre del autor no debe tener números';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Agregar libro'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                ),
                onPressed: _guardarLibro,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
