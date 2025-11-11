// ===== Class Dasar: Expense =====
class Expense {
  String _description;
  double _amount;
  String _category;
  DateTime _date;

  Expense({
    required String description,
    required double amount,
    required String category,
    DateTime? date,
  })  : _description = description,
        _amount = amount,
        _category = category,
        _date = date ?? DateTime.now();

  // Getter
  String get description => _description;
  double get amount => _amount;
  String get category => _category;
  DateTime get date => _date;

  // Method sederhana untuk menampilkan info
  void printDetails() {
    String d =
        '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}';
    print('[$_category] $_description - Rp${_amount.toStringAsFixed(2)} ($d)');
  }
}

// ===== Class Turunan: TravelExpense =====
class TravelExpense extends Expense {
  String destination;
  int tripDuration; // dalam hari

  TravelExpense({
    required String description,
    required double amount,
    required this.destination,
    required this.tripDuration,
    DateTime? date,
  }) : super(
          description: description,
          amount: amount,
          category: 'Perjalanan',
          date: date ?? DateTime.now(),
        );

  // Menghitung biaya per hari
  double getDailyCost() {
    if (tripDuration == 0) return amount;
    return amount / tripDuration;
  }

  // Mengecek apakah destinasi internasional (cek sederhana)
  bool isInternational() {
    return destination.contains('Jepang') ||
        destination.contains('Singapura') ||
        destination.contains('Malaysia') ||
        destination.contains('Korea') ||
        destination.contains('Thailand') ||
        destination.contains('Amerika');
  }

  // Override method printDetails()
  @override
  void printDetails() {
    print('✈ PENGELUARAN PERJALANAN');
    super.printDetails();
    print('   Destinasi: $destination');
    print('   Durasi: $tripDuration hari');
    print('   Biaya harian: Rp${getDailyCost().toStringAsFixed(2)}');
    print('   Internasional: ${isInternational() ? "Ya 🌍" : "Tidak 🏠"}');
  }
}

// ===== Main Function =====
void main() {
  var trip = TravelExpense(
    description: 'Liburan Tokyo',
    amount: 25000000.0,
    destination: 'Tokyo, Jepang',
    tripDuration: 7,
  );

  trip.printDetails();
}