import 'dart:convert';
import 'package:http/http.dart' as http;

class PayService {
  final String payUrl = 'http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com/api/qr/pay';

  Future<Map<String, dynamic>> payQr(String qrCode) async {
    final response = await http.post(
      Uri.parse(payUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'qrCode': qrCode}),
    );

    if (response.statusCode != 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process payment: ${response.body}');
    }
  }
}
