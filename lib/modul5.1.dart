class Expense {
  String description;
  double amount;
  String category;
  DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  // hitung hari ke-berapa dalam tahun tanpa DateFormat
  int _dayOfYear() {
    final startOfYear = DateTime(date.year, 1, 1);
    return date.difference(startOfYear).inDays + 1; 
  }

  int getWeekNumber() {
    final dayOfYear = _dayOfYear();
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  int getQuarter() {
    return ((date.month - 1) / 3).floor() + 1;
  }

  bool isWeekend() {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
}

void main() {
  var expense = Expense(
    description: 'Brunch akhir pekan',
    amount: 45.00,
    category: 'Makanan',
    date: DateTime(2025, 10, 11), 
  );

  print('Kuartal: ${expense.getQuarter()}');
  print('Minggu ke: ${expense.getWeekNumber()}');
  print('Akhir pekan? ${expense.isWeekend()}');
}