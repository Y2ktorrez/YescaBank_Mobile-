import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yescabank/models/estracto_model.dart';

class TransactionService {
  final String baseUrl = 'http://192.168.132.99:3000/api/transaction/transactionNot';

  Future<Transaction> fetchTransaction(String accountNumber) async {
    final response = await http.get(Uri.parse('$baseUrl/$accountNumber'));

    if (response.statusCode == 200) {
      // Check if the response is a list or a single object
      dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        // If it's a list, return the first element
        return Transaction.fromJson(jsonResponse.first);
      } else {
        // If it's a single object, return it directly
        return Transaction.fromJson(jsonResponse);
      }
    } else {
      throw Exception('Failed to load transaction');
    }
  }
}