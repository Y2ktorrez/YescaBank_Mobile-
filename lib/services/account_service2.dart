import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yescabank/services/token_storage.dart';
import 'package:yescabank/models/account_activity.dart';

class AccountService {
  final String _baseUrl = 'http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com/api/account/get-acountcus';
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<AccountActivity>> getAccountActivity() async {
    final token = await _tokenStorage.getToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
        final accountData = jsonData['data'][0];
        final balance = double.parse(accountData['balance']);
        final updateAt = DateTime.parse(accountData['updateAt']);
        final createAt = DateTime.parse(accountData['createAt']);

        // Simulación de cambios de saldo con datos ficticios (alta y baja de saldo)
        List<AccountActivity> activityList = [
          AccountActivity(date: createAt, balance: 0),
          AccountActivity(date: updateAt, balance: balance),
        ];

        return activityList;
      } else {
        throw Exception('No account data found');
      }
    } else {
      throw Exception('Failed to load account data');
    }
  }
}
