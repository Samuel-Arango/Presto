import 'package:flutter/foundation.dart';

import 'book.dart';

const int loanDays = 15;

class Loan {
  final String user;
  final Book book;
  final DateTime date;
  final DateTime? returnedDate;

  const Loan({
    required this.user,
    required this.book,
    required this.date,
    this.returnedDate,
  });

  DateTime get dueDate => dueDateFrom(date);

  bool get isReturned => returnedDate != null;

  bool get isOverdue => !isReturned && DateTime.now().isAfter(dueDate);

  Loan copyWith({DateTime? returnedDate, bool clearReturned = false}) {
    return Loan(
      user: user,
      book: book,
      date: date,
      returnedDate: clearReturned ? null : (returnedDate ?? this.returnedDate),
    );
  }
}

DateTime dueDateFrom(DateTime date) {
  return DateTime(date.year, date.month, date.day + loanDays);
}

String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

final ValueNotifier<List<Loan>> loans = ValueNotifier<List<Loan>>([]);

void addLoan(Loan loan) {
  loans.value = [...loans.value, loan];
}

// Marca un préstamo como devuelto (fecha actual). Devuelve true si se encontró.
bool returnLoan(Loan target) {
  final index = loans.value.indexOf(target);
  if (index == -1) return false;
  final updated = [...loans.value];
  updated[index] = updated[index].copyWith(returnedDate: DateTime.now());
  loans.value = updated;
  return true;
}

// Lista de préstamos activos (no devueltos).
List<Loan> activeLoans() => loans.value.where((l) => !l.isReturned).toList();

// Lista de préstamos devueltos.
List<Loan> returnedLoans() => loans.value.where((l) => l.isReturned).toList();
