import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yescabank/models/transaction_model.dart';

class TransactionService {
  static const String createUrl =
      'http://192.168.0.10:3000/api/transaction/create';
  static const String extractUrl =
      'http://192.168.0.10:3000/api/transaction/transactionNot/';

  // Crear transacción
  Future<Map<String, dynamic>> createTransaction(Transaction transaction) async {
    final response = await http.post(
      Uri.parse(createUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      print('Transacción exitosa: $jsonResponse');
      return jsonResponse;
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al realizar la transacción: ${response.body}');
    }
  }

  // Obtener extracto de transacciones por número de cuenta
  Future<List<Transaction>> getTransactions(String nroAccount) async {
    final response = await http.get(Uri.parse('$extractUrl$nroAccount'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body)['data'];
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } else {
      print('Error al obtener las transacciones: ${response.statusCode}');
      throw Exception('Error al obtener las transacciones');
    }
  }
}