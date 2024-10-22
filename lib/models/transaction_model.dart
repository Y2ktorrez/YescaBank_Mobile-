class Transaction {
  final double amount;
  final String nroAccountDestin;
  final String description;
  final String accountOrigin;
  final String typeTransacctionName;

  Transaction({
    required this.amount,
    required this.nroAccountDestin,
    required this.description,
    required this.accountOrigin,
    required this.typeTransacctionName,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'nroAccountDestin': nroAccountDestin,
      'description': description,
      'accountOrigin': accountOrigin,
      'typeTransacctionName': typeTransacctionName,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      nroAccountDestin: json['nroAccountDestin'] ?? '',
      description: json['description'] ?? '',
      accountOrigin: json['accountOrigin'] ?? '',
      typeTransacctionName: json['typeTransacctionName'] ?? '',
    );
  }
}
