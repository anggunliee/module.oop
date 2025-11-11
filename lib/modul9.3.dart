class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  void printDetails() {
    print('$description - Rp${amount.toStringAsFixed(2)} (${category}) [${date.toLocal()}]');
  }
}

class Budget {
  final String category;
  final double limit;
  double _spent = 0;

  Budget({required this.category, required this.limit});

  void addExpense(double amount) {
    _spent += amount;
    if (_spent > limit) {
      print('Kategori "$category" telah melewati limit!');
    } else if (_spent >= limit * 0.9) {
      print('Kategori "$category" hampir mencapai limit!');
    }
  }

  double get remaining => limit - _spent;

  void printSummary() {
    print('$category: Rp${_spent.toStringAsFixed(2)} / Rp${limit.toStringAsFixed(2)}');
  }
}

class BudgetManager {
  final Map<String, Budget> _budgets = {};

  void setBudget(String category, double limit) {
    _budgets[category] = Budget(category: category, limit: limit);
    print('Budget untuk "$category" diset Rp${limit.toStringAsFixed(2)}');
  }

  void addExpense(String category, double amount) {
    if (_budgets.containsKey(category)) {
      _budgets[category]!.addExpense(amount);
    }
  }

  void printAllBudgets() {
    print('=== Laporan Budget =====');
    if (_budgets.isEmpty) {
      print('Belum ada budget.');
      return;
    }
    _budgets.forEach((key, b) => b.printSummary());
  }
}

class UserAccount {
  final String username;
  final String password;
  String currency = 'IDR';
  final List<Expense> _expenses = [];
  final BudgetManager budgetManager = BudgetManager();

  UserAccount({
    required this.username,
    required this.password,
  });

  void addExpense(Expense e) {
    _expenses.add(e);
    budgetManager.addExpense(e.category, e.amount);
  }

  void printProfile() {
    print('Profil Pengguna: $username');
    print('Mata uang: $currency');

    double total = _expenses.fold(0.0, (sum, e) => sum + e.amount);

    print('Total pengeluaran: Rp${total.toStringAsFixed(2)}');
  }

  void printExpenses() {
    print('Daftar Pengeluaran ($username)');
    if (_expenses.isEmpty) {
      print('Belum ada pengeluaran.');
      return;
    }
    for (var e in _expenses) {
      e.printDetails();
    }
  }
}

class FinanceSystem {
  final Map<String, UserAccount> _users = {};
  UserAccount? _currentUser;

  void register(String username, String password) {
    if (_users.containsKey(username)) {
      print('Username sudah digunakan');
      return;
    }
    _users[username] = UserAccount(username: username, password: password);
    print('Akun "$username" berhasil dibuat!');
  }

  bool login(String username, String password) {
    if (!_users.containsKey(username)) {
      print('Username tidak ditemukan');
      return false;
    }
    if (_users[username]!.password != password) {
      print('Password salah');
      return false;
    }
    _currentUser = _users[username];
    print('Selamat datang, $username!');
    return true;
  }

  void logout() {
    if (_currentUser == null) {
      print('Belum login.');
      return;
    }
    print('Logout dari akun ${_currentUser!.username}');
    _currentUser = null;
  }

  void addExpense(String description, double amount, String category) {
    if (_currentUser == null) {
      print('Harus login dulu!');
      return;
    }
    var exp = Expense(description: description, amount: amount, category: category);
    _currentUser!.addExpense(exp);
    print('Pengeluaran ditambahkan untuk ${_currentUser!.username}');
  }

  void showUserReport() {
    if (_currentUser == null) {
      print('Harus login dulu!');
      return;
    }
    _currentUser!.printProfile();
    _currentUser!.printExpenses();
    _currentUser!.budgetManager.printAllBudgets();
  }
}

void main() {
  var app = FinanceSystem();

  // Registrasi dua user
  app.register('alice', '1234');
  app.register('bob', '5678');

  // Login sebagai Alice 
  app.login('alice', '1234');
  app._currentUser!.budgetManager.setBudget('Makanan', 500000);
  app._currentUser!.budgetManager.setBudget('Transportasi', 300000);

  app.addExpense('Sarapan', 40000, 'Makanan');
  app.addExpense('Ojek Online', 25000, 'Transportasi');
  app.addExpense('Makan Siang', 100000, 'Makanan');

  app.showUserReport();
  app.logout();

  // Login sebagai Bob 
  app.login('bob', '5678');
  app._currentUser!.budgetManager.setBudget('Hiburan', 200000);

  app.addExpense('Nonton bioskop', 75000, 'Hiburan');
  app.addExpense('Ngopi', 50000, 'Hiburan');

  app.showUserReport();
  app.logout();
}