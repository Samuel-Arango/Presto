import 'package:flutter/material.dart';

import '../models_books/book.dart';
import '../models_books/loan.dart';

// Pantalla para registrar el préstamo de un libro a un usuario (RF09).
class LoanRegistration extends StatefulWidget {
  const LoanRegistration({super.key});

  @override
  State<LoanRegistration> createState() => _LoanRegistrationState();
}

class _LoanRegistrationState extends State<LoanRegistration> {
  // Permite validar todos los campos del formulario a la vez.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  Book? _book;
  DateTime? _date;
  // Cambia al registrar un préstamo para reiniciar el desplegable de libros.
  int _formVersion = 0;

  @override
  void initState() {
    super.initState();
    // Por defecto, la fecha del préstamo es hoy.
    _setDate(DateTime.now());
  }

  @override
  void dispose() {
    _userController.dispose();
    _dateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  // Guarda la fecha del préstamo y calcula la fecha de devolución.
  void _setDate(DateTime date) {
    _date = date;
    _dateController.text = formatDate(date);
    _dueDateController.text = formatDate(dueDateFrom(date));
  }

  // Abre el calendario para elegir la fecha del préstamo.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _setDate(picked));
    }
  }

  // Valida el formulario, guarda el préstamo, avisa y limpia los campos.
  void _registerLoan() {
    if (_formKey.currentState!.validate()) {
      final loan = Loan(
        user: _userController.text.trim(),
        book: _book!,
        date: _date!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Préstamo de "${loan.book.title}" registrado a ${loan.user}. '
            'Devolución: ${formatDate(loan.dueDate)}',
          ),
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        addLoan(loan);
        _book = null;
        _formVersion++;
        _setDate(DateTime.now());
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
        title: const Text("Registro de préstamos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Usuario: campo obligatorio.
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Libro: se elige de la lista del catálogo.
              DropdownButtonFormField<Book>(
                key: ValueKey(_formVersion),
                initialValue: _book,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Libro',
                  prefixIcon: Icon(Icons.book),
                ),
                items: [
                  for (final book in catalog)
                    DropdownMenuItem(
                      value: book,
                      child: Text(book.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _book = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona un libro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fecha del préstamo: solo se cambia con el calendario.
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha del préstamo',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona la fecha del préstamo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fecha de devolución: solo lectura, se calcula sola.
              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de devolución',
                  helperText: 'Se calcula $loanDays días después del préstamo',
                  prefixIcon: Icon(Icons.event_available),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Registrar préstamo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                ),
                onPressed: _registerLoan,
              ),

              // Lista de los préstamos registrados (el más reciente primero).
              if (loans.value.isNotEmpty) ...[
                const SizedBox(height: 32),
                const Text(
                  'Préstamos registrados',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (final loan in loans.value.reversed)
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(loan.book.title),
                    subtitle: Text(
                      '${loan.user}\n'
                      'Préstamo: ${formatDate(loan.date)}  ·  '
                      'Devolución: ${formatDate(loan.dueDate)}',
                    ),
                    isThreeLine: true,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
