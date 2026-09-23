import 'package:flutter/foundation.dart';

import 'book.dart';

const int loanDays = 15;

class Loan {
  final String user;
  final Book book;
  final DateTime date;

  const Loan({required this.user, required this.book, required this.date});

  DateTime get dueDate => dueDateFrom(date);
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
