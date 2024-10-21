import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yescabank/models/estracto_model.dart';

class TransactionService {
  final String baseUrl = 'http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com/api/type-account/create-interest';

  Future<List<Transaction>> fetchTransactions(String accountNumber) async {
    final response = await http.get(Uri.parse('$baseUrl/$accountNumber'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}