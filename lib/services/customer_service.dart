import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/createCustomer_model.dart';

class CustomerService {
  static const String baseUrl = 'http://ec2-18-188-191-141.us-east-2.compute.amazonaws.com/api/customer/create'; //Aca cambia la IP de tu laptop

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