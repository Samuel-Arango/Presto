import 'package:flutter/foundation.dart';

import 'book.dart';

// Días de plazo que tiene el usuario para devolver el libro.
const int loanDays = 15;

// Un préstamo: quién lo hizo, qué libro es y desde cuándo.
class Loan {
  final String user;
  final Book book;
  final DateTime date;

  const Loan({required this.user, required this.book, required this.date});

  // La fecha de devolución no se guarda: se calcula desde la fecha del préstamo.
  DateTime get dueDate => dueDateFrom(date);
}

// Suma los días del plazo; DateTime ajusta solo el mes y el año si hace falta.
DateTime dueDateFrom(DateTime date) {
  return DateTime(date.year, date.month, date.day + loanDays);
}

// Muestra la fecha como AAAA-MM-DD.
String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

// Lista de préstamos "observable": los widgets que la escuchan se
// actualizan solos cuando cambia.
final ValueNotifier<List<Loan>> loans = ValueNotifier<List<Loan>>([]);

// Se crea una lista nueva (no se modifica la anterior) para que el
// ValueNotifier detecte el cambio y avise.
void addLoan(Loan loan) {
  loans.value = [...loans.value, loan];
}
