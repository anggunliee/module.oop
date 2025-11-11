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

class RecurringExpense extends Expense {
  String frequency;

  RecurringExpense({
    required String description,
    required double amount,
    required String category,
    required this.frequency,
    DateTime? date,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          date: date ?? DateTime.now(),
        );

  double yearlyTotal() {
    switch (frequency) {
      case 'harian':
        return _amount * 365;
      case 'mingguan':
        return _amount * 52;
      case 'bulanan':
        return _amount * 12;
      case 'tahunan':
        return _amount;
      default:
        return _amount;
    }
  }
}

class SubscriptionExpense extends RecurringExpense {
  String provider;
  String plan;
  DateTime startDate;
  DateTime? endDate;

  SubscriptionExpense({
    required String description,
    required double amount,
    required this.provider,
    required this.plan,
    required this.startDate,
    this.endDate,
  }) : super(
          description: description,
          amount: amount,
          category: 'Langganan',
          frequency: 'bulanan',
        );

  bool isActive() {
    DateTime now = DateTime.now();
    if (endDate == null) return true;
    return now.isBefore(endDate!);
  }

  int getRemainingMonths() {
    if (endDate == null) return -1;
    DateTime now = DateTime.now();
    if (now.isAfter(endDate!)) return 0;

    int months = (endDate!.year - now.year) * 12 + (endDate!.month - now.month);
    return months;
  }

  double getTotalCost() {
    if (endDate == null) {
      return yearlyTotal();
    }

    int months = (endDate!.year - startDate.year) * 12 + (endDate!.month - startDate.month);
    return _amount * months;
  }

  @override
  void printDetails() {
    print('📱 LANGGANAN');
    print('$description ($provider - $plan)');
    print('Biaya: Rp${_amount.toStringAsFixed(2)}/bulan');
    print('Mulai: ${startDate.toString().split(' ')[0]}');

    if (endDate != null) {
      print('Berakhir: ${endDate.toString().split(' ')[0]}');
      print('Sisa: ${getRemainingMonths()} bulan');
    } else {
      print('Berakhir: Tidak pernah (berkelanjutan)');
    }

    print('Status: ${isActive() ? "Aktif ✅" : "Expired ❌"}');
    print('Total biaya: Rp${getTotalCost().toStringAsFixed(2)}');
  }
}

void main() {
  var netflix = SubscriptionExpense(
    description: 'Netflix Premium',
    amount: 186000,
    provider: 'Netflix',
    plan: 'Premium 4K',
    startDate: DateTime(2024, 1, 1),
    endDate: null,
  );

  var trial = SubscriptionExpense(
    description: 'Adobe Creative Cloud',
    amount: 800000,
    provider: 'Adobe',
    plan: 'Semua Apps',
    startDate: DateTime(2025, 9, 1),
    endDate: DateTime(2025, 12, 31),
  );

  netflix.printDetails();
  print('');
  trial.printDetails();
}