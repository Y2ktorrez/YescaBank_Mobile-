import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yescabank/screens/qr_scanner.dart';
import 'package:yescabank/services/qr_service.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  String? _qrImageBase64;
  bool _isLoading = false;

  Future<void> _generateQr() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      "amount": double.parse(_amountController.text),
      "reference": _referenceController.text,
      "singleUse": true,
      "expiresAt": "2024-12-31T23:59:59.000Z",
    };

    try {
      final qrService = QrService();
      final response = await qrService.generateQr(data);

      setState(() {
        _qrImageBase64 = response['data']['qrCode'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR generado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar QR: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerPage(
          onScanCompleted: (amount) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Enviado exitosamente: Monto $amount')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 124, 150),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 124, 150),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'QR Generator & Scanner',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // FORMULARIO
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el monto';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingresa un monto válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _referenceController,
                      decoration: InputDecoration(
                        labelText: 'Referencia',
                        prefixIcon: const Icon(Icons.tag, color: Colors.white),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una referencia';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // BOTÓN PARA GENERAR QR
              ElevatedButton(
                onPressed: _isLoading ? null : _generateQr,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color.fromARGB(255, 5, 124, 150))
                    : const Text(
                        'Generar QR',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 124, 150),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // BOTÓN PARA ESCANEAR QR
              ElevatedButton(
                onPressed: _openQrScanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Escanear QR',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 124, 150),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // MOSTRAR QR GENERADO
              if (_qrImageBase64 != null) ...[
                const Text(
                  'QR Generado:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Image.memory(
                  base64Decode(_qrImageBase64!.split(',')[1]),
                  height: 200,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
