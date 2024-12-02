import 'package:flutter/material.dart';
import 'package:yescabank/services/qr_service.dart';
import 'package:yescabank/models/qr_response.dart';
import 'package:yescabank/widgets/qr_image_widget.dart';
import 'package:yescabank/screens/qr_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final QrService _qrService = QrService();
  QrResponse? _qrResponse;
  bool _isLoading = false;

  Future<void> generateQr() async {
    setState(() => _isLoading = true);

    try {
      final data = {
        "amount": 100.50,
        "reference": "REF11111125",
        "singleUse": true,
        "expiresAt": "2024-12-31T23:59:59.000Z",
      };

      final response = await _qrService.generateQr(data);
      setState(() {
        _qrResponse = QrResponse.fromJson(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Generator & Scanner'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: generateQr,
                    child: const Text('Generate QR'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: openQrScanner,
                    child: const Text('Lector QR'),
                  ),
                  const SizedBox(height: 20),
                  if (_qrResponse != null) ...[
                    const Text('QR Code:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    QrImageWidget(base64String: _qrResponse!.qrCode),
                  ]
                ],
              ),
      ),
    );
  }
}
