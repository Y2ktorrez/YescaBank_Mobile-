import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yescabank/models/transaction_model.dart';

class TransactionService {
  static const String extractUrl =
      'http://192.168.0.10:3000/api/transaction/transactionNot/';

  // Obtener extracto de transacciones por número de cuenta y tipo de transacción
  Future<List<Transaction>> getTransactions(String nroAccount, {String? transactionType}) async {
    final response = await http.get(Uri.parse('$extractUrl$nroAccount'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body)['data'];
      List<Transaction> transactions = jsonList.map((json) => Transaction.fromJson(json)).toList();

      // Filtrar por tipo de transacción si se especifica
      if (transactionType != null) {
        transactions = transactions.where((transaction) => transaction.typeTransacctionName == transactionType).toList();
      }

      return transactions;
    } else {
      print('Error al obtener las transacciones: ${response.statusCode}');
      throw Exception('Error al obtener las transacciones');
    }
  }
}