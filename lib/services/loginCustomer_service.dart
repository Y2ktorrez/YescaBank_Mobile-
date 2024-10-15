import 'package:yescabank/models/login_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LogincustomerService {
  static const String baseUrl = 'http://192.168.0.15:3001/api/customer/login';

  Future<String?> loginCustomer(LoginCustomer loginCustomer) async {
    print('Enviando solicitud a $baseUrl');
    print('Datos enviados: ${jsonEncode(loginCustomer.toJson())}');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginCustomer.toJson()),
    );

    // Aquí usamos el bloque de código que mencionaste
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print('Login exitoso, token recibido: ${jsonResponse['token']}');
      return jsonResponse['token'];
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to login customer: ${response.body}');
    }
  }
}