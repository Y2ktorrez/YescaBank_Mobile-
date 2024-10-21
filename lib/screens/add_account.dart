import 'package:flutter/material.dart';
import '../models/customerAccount_model.dart';
import '../services/account_service.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final AccountService _accountService = AccountService();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedCurrency = "USD"; // Moneda predeterminada
  String _selectedAccountType = "Cuenta Corriente"; // Tipo de cuenta predeterminada

  // Método para registrar la cuenta
  Future<void> _createAccount() async {
    if (_ciController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final account = CustomerAccount(
      ci: int.parse(_ciController.text),
      typeCurencyName: _selectedCurrency,
      typeAccountName: _selectedAccountType,
      contratEmail: _emailController.text,
    );

    try {
      await _accountService.createAccount(account);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Cuenta'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            const Text(
              'Completa los detalles de la cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Campo CI
            _buildTextField(
              controller: _ciController,
              label: "CI",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Campo Email
            _buildTextField(
              controller: _emailController,
              label: "Email",
            ),
            const SizedBox(height: 20),

            // Selector de tipo de moneda
            _buildDropdown(
              label: "Selecciona el Tipo de Moneda",
              value: _selectedCurrency,
              items: ['USD', 'EUR', 'BOB'],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Selector de tipo de cuenta
            _buildDropdown(
              label: "Selecciona el Tipo de Cuenta",
              value: _selectedAccountType,
              items: ['Cuenta Corriente', 'Cuenta de Ahorro'],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAccountType = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Botón de Crear Cuenta
            ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Cambiado de 'primary' a 'backgroundColor'
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200 ],
      ),
      cursorColor: Colors.teal,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}