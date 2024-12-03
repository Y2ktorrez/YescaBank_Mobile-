import 'dart:convert';
import 'package:http/http.dart' as http;

class QrService {
  final String baseUrl = 'http://ec2-18-222-213-118.us-east-2.compute.amazonaws.com';

  Future<Map<String, dynamic>> generateQr(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/qr/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate QR code');
    }
  }

  Future<Map<String, dynamic>> validateQr(String qrCode) async {
    final response = await http.post(
      Uri.parse('$baseUrl/qr/validate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'qrCode': qrCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('QR Code validation failed');
    }
  }

  Future<Map<String, dynamic>> payQr(String qrCode) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/qr/pay'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'qrCode': qrCode}),
    );

    if (response.statusCode != 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Payment processing failed');
    }
  }
}
