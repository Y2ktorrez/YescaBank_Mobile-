import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  final void Function(double amount) onScanCompleted;

  const QRScannerPage({Key? key, required this.onScanCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.teal,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          for (final barcode in capture.barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              final amount = _extractAmountFromQrCode(code);
              onScanCompleted(amount); // Llamar al callback
              Navigator.of(context).pop(); // Cerrar la cámara y regresar
              break;
            }
          }
        },
      ),
    );
  }

  double _extractAmountFromQrCode(String code) {
    // Simular la extracción de un monto desde el código
    return 100.50; // Personaliza esta lógica según tu necesidad
  }
}
