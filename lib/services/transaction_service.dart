import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yescabank/models/transaction_model.dart';

class TransactionService {
  static const String baseUrl = 'http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com/api/transaction/create';

  Future<Map<String, dynamic>> createTransaction(Transaction transaction) async {
    final response = await http.post(
      Uri.parse(baseUrl),
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
}