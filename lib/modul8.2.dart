// PaymentMethod (abstrak)
abstract class PaymentMethod {
  String get name;
  String get icon;

  void processPayment(double amount);

  void showReceipt(double amount) {
    print('✅ Pembayaran sebesar \$${amount.toStringAsFixed(2)} berhasil!');
  }
}

// Interface Refundable
abstract class Refundable {
  bool canRefund();
  void processRefund(double amount);
}

// Implementasi CreditCard (refundable)
class CreditCard extends PaymentMethod implements Refundable {
  final String cardNumber;
  final String cardHolder;
  final List<double> transactions = [];

  CreditCard({
    required this.cardNumber,
    required this.cardHolder,
  });

  @override
  String get name => 'Kartu Kredit';

  @override
  String get icon => '💳';

  @override
  void processPayment(double amount) {
    transactions.add(amount);
    print('$icon Mendebet \$${amount.toStringAsFixed(2)} untuk $cardHolder');
    showReceipt(amount);
  }

  @override
  bool canRefund() => transactions.isNotEmpty;

  @override
  void processRefund(double amount) {
    if (!canRefund()) {
      print('❌ Tidak ada transaksi untuk direfund');
      return;
    }
    print('🔄 Memproses refund \$${amount.toStringAsFixed(2)} ke kartu $cardNumber');
    print('   Refund akan muncul dalam 3–5 hari kerja');
    transactions.add(-amount);
  }
}

// Cash (tidak refundable)
class Cash extends PaymentMethod {
  @override
  String get name => 'Tunai';

  @override
  String get icon => '💵';

  @override
  void processPayment(double amount) {
    print('$icon Pembayaran tunai: \$${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }
}

void main() {
  PaymentMethod card = CreditCard(
    cardNumber: '4532123456789012',
    cardHolder: 'John Doe',
  );

  PaymentMethod cash = Cash();

  // Transaksi kartu
  card.processPayment(100.0);

  // PERBAIKAN: cast ke Refundable sebelum memanggil processRefund
  if (card is Refundable) {
    // dua cara: (card as Refundable).processRefund(50.0);
    // atau simpan ke variabel lokal:
    final refundable = card as Refundable;
    refundable.processRefund(50.0);
  }

  print('\n---\n');

  // Transaksi tunai
  cash.processPayment(50.0);

  if (cash is Refundable) {
    (cash as Refundable).processRefund(25.0);
  } else {
    print('❌ Pembayaran tunai tidak dapat direfund');
  }
}