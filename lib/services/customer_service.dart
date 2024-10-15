import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/createCustomer_model.dart';
import '../models/login_model.dart';

class CustomerService {
  static const String baseUrl = 'http://tudominio.com/api/customers'; //Esto vamos a cambiar

  Future<void> createCustomer(Customer customer) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create customer');
    }
  }

  Future<String?> loginCustomer(LoginCustomer loginCustomer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginCustomer.toJson()),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['token'];
    } else {
      throw Exception('Failed to login customer');
    }
  }
}