import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yescabank/services/token_storage.dart';

class CustomerData {
  final String name;
  final String lastName;
  final String nroAccount;
  final String balance;
  final String typeAccount;
  final String typeCurrency;
  final String createAt;
  final String updateAt;
  final String state;

  CustomerData({
    required this.name,
    required this.lastName,
    required this.nroAccount,
    required this.balance,
    required this.typeAccount,
    required this.typeCurrency,
    required this.createAt,
    required this.updateAt,
    required this.state,
  });
}

class CustomerServiceB {
  final String _baseUrl = 'http://192.168.132.99:3000/api/account/get-acountcus'; // Asegúrate de que esta URL sea correcta
  final TokenStorage _tokenStorage = TokenStorage();

  Future<CustomerData> getCustomerData() async {
    final token = await _tokenStorage.getToken();
    final response = await http.get(Uri.parse(_baseUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
        final customer = jsonData['data'][0]['customer'];
        final account = jsonData['data'][0];
        return CustomerData(
          name: customer['name'],
          lastName: customer['lastName'],
          nroAccount: account['nroAccount'],
          balance: account['balance'],
          typeAccount: account['typeAccount']['name'], // Tipo de cuenta
          typeCurrency: account['typeCurrency']['codeIso'], // Tipo de moneda
          createAt: account['createAt'], // Fecha de creación
          updateAt: account['updateAt'], // Fecha de última actualización
          state: account['state'], // Estado de la cuenta
        );
      } else {
        throw Exception('No customer data found');
      }
    } else {
      throw Exception('Failed to load customer data');
    }
  }
}