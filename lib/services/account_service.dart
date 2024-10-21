import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customerAccount_model.dart';

class AccountService {
  final String baseUrl = 'http://192.168.132.99:3000/api/account/create';

  Future<void> createAccount(CustomerAccount account) async {
    try {
      // Construir la URL con el CI
      final url = '$baseUrl/${account.ci}';

      // Hacer la solicitud POST
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'typeCurencyName': account.typeCurencyName,
          'typeAccountName': account.typeAccountName,
          'contratEmail': account.contratEmail,
        }),
      );

      // Verificar el estado de la respuesta
      if (response.statusCode != 200) {
        throw Exception('Failed to create account: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }
}