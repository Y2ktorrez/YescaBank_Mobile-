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
  final String _baseUrl = 'http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com/api/account/get-acountcus';
  final TokenStorage _tokenStorage = TokenStorage();

//http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com/api/transaction/transactionNot

  Future<List<CustomerData>> getCustomerData() async {
    final token = await _tokenStorage.getToken();
    final response = await http.get(Uri.parse(_baseUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
        List<CustomerData> accounts = [];
        for (var account in jsonData['data']) {
          final customer = account['customer'];
          accounts.add(CustomerData(
            name: customer['name'],
            lastName: customer['lastName'],
            nroAccount: account['nroAccount'],
            balance: account['balance'],
            typeAccount: account['typeAccount']['name'],
            typeCurrency: account['typeCurrency']['codeIso'],
            createAt: account['createAt'],
            updateAt: account['updateAt'],
            state: account['state'],
          ));
        }
        return accounts;
      } else {
        throw Exception('No customer data found');
      }
    } else {
      throw Exception('Failed to load customer data');
    }
  }
}