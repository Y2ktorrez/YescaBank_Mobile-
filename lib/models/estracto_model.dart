class Transaction {
  final int id;
  final String amount;
  final String date;
  final String hour;
  final String description;
  final String nroAccountOrig;
  final String nroAccountDestin;
  final bool isOrigin;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.hour,
    required this.description,
    required this.nroAccountOrig,
    required this.nroAccountDestin,
    required this.isOrigin,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      date: json['date'],
      hour: json['hour'],
      description: json['description'],
      nroAccountOrig: json['nroAccountOrig'],
      nroAccountDestin: json['nroAccountDestin'],
      isOrigin: json['isogrin'],
    );
  }
}