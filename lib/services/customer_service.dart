import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/createCustomer_model.dart';

class CustomerService {
  static const String baseUrl = 'http://192.168.0.10:3000/api/customer/create'; //Aca cambia la IP de tu laptop

  Future<void> createCustomer(Customer customer) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create customer');
    }
  }
}