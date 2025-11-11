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

  void printDetails() {
    print('Deskripsi: $description');
    print('Jumlah: ${getFormattedAmount()}');
    print('Kategori: $category');
    print('Tanggal: ${_date.day}/${_date.month}/${_date.year}');
    print('Akhir pekan: ${isWeekend() ? "Ya" : "Tidak"}');
    print('Kuartal: ${getQuarter()}');
  }
}

class BusinessExpense extends Expense {
  String client;
  bool isReimbursable;

  BusinessExpense({
    required String description,
    required double amount,
    required String category,
    required this.client,
    this.isReimbursable = true,
  }) : super(
    description: description,
    amount: amount,
    category: category,
    date: DateTime.now(),
  );

  @override
  void printDetails() {
    print('💼 PENGELUARAN BISNIS');
    super.printDetails();
    print('   Klien: $client');
    print('   Bisa di-reimburse: ${isReimbursable ? "Ya ✅" : "Tidak ❌"}');
  }
}

void main() {
  var expense = BusinessExpense(
    description: 'Makan siang klien',
    amount: 85.0,
    category: 'Makan',
    client: 'PT Acme',
    isReimbursable: true,
  );

  expense.printDetails();
}