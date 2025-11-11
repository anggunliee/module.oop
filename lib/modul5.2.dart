class Expense {
  final String description;
  final double _amount;
  final String category;
  final DateTime _date;

  Expense({
    required this.description,
    required double amount,
    required this.category,
    DateTime? date,
  }) : _amount = amount,
       _date = date ?? DateTime.now();

  int getWeekNumber() {
    DateTime firstDayOfYear = DateTime(_date.year, 1, 1);
    int dayOfYear = _date.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear - _date.weekday + 10) / 7).floor();
  }

  int getQuarter() {
    return ((_date.month - 1) / 3).floor() + 1;
  }

  bool isWeekend() {
    return _date.weekday == DateTime.saturday || _date.weekday == DateTime.sunday;
  }

  String getFormattedAmount() {
    return 'Rp${_amount.toStringAsFixed(2)}';
  }

  double getAmountRounded() {
    return _amount.roundToDouble();
  }

  double getDailyAverage(int days) {
    if (days <= 0) return 0;
    return _amount / days;
  }

  double projectedYearly() {
    return _amount * 12;
  }
}

void main() {
  var subscription = Expense(
    description: 'Netflix',
    amount: 15.99,
    category: 'Hiburan',
  );

  print('Jumlah: ${subscription.getFormattedAmount()}');
  print('Dibulatkan: Rp${subscription.getAmountRounded().toStringAsFixed(2)}');
  print('Rata-rata harian (30 hari): Rp${subscription.getDailyAverage(30).toStringAsFixed(2)}');
  print('Proyeksi tahunan: Rp${subscription.projectedYearly().toStringAsFixed(2)}');
}