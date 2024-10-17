import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yescabank/services/token_storage.dart';

class CustomerData {
  final String name;
  final String lastName;
  final String nroAccount;
  final String balance;

  CustomerData(this.name, this.lastName, this.nroAccount, this.balance);
}

class CustomerServiceB {
  final String _baseUrl = 'http://192.168.0.6:3000/api/account/get-acountcus'; // Asegúrate de que esta URL sea correcta
  final TokenStorage _tokenStorage = TokenStorage();

  Future<CustomerData> getCustomerData() async {
    final token = await _tokenStorage.getToken();
    final response = await http.get(Uri.parse(_baseUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Asegúrate de que la estructura del JSON se maneje correctamente
      if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
        final customer = jsonData['data'][0]['customer'];
        final account = jsonData['data'][0];
        final name = customer['name'];
        final lastName = customer['lastName'];
        final nroAccount = account['nroAccount'];
        final balance = account['balance'];

        return CustomerData(name, lastName, nroAccount, balance);
      } else {
        throw Exception('No customer data found');
      }
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  Future<String> getCustomerName() async {
    final token = await _tokenStorage.getToken();
    final response = await http.get(Uri.parse(_baseUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Asegúrate de que la estructura del JSON se maneje correctamente
      if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
        final customer = jsonData['data'][0]['customer'];
        final customerName = '${customer['name']} ${customer['lastName']}';
        return customerName;
      } else {
        throw Exception('No customer data found');
      }
    } else {
      throw Exception('Failed to load customer name');
    }
  }
}