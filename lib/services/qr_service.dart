import 'dart:convert';
import 'package:http/http.dart' as http;

class QrService {
  final String baseUrl = 'http://192.168.0.10:3000/api/qr';

  Future<Map<String, dynamic>> generateQr(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate QR code');
    }
  }
}
