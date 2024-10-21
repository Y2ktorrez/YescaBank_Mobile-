import 'package:flutter/material.dart';
import '../models/customerAccount_model.dart';
import '../services/account_service.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage>
    with SingleTickerProviderStateMixin {
  final AccountService _accountService = AccountService();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedCurrency = "USD";
  String _selectedAccountType = "Cuenta Corriente";

  late AnimationController _animationController;
  late Animation<double> _buttonScaleAnimation;

  // Método para registrar la cuenta
  Future<void> _createAccount() async {
    if (_ciController.text.isEmpty || _emailController.text.isEmpty) {
      _showSnackBar('Por favor, completa todos los campos.');
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
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Cuenta'),
        backgroundColor: const Color.fromARGB(255, 2, 143, 148), 
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildAnimatedTitle(),
            const SizedBox(height: 30),

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
            const SizedBox(height: 40),

            // Botón de Crear Cuenta con animación
            _buildAnimatedButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: const Text(
        'Completa los detalles de la cuenta',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        textAlign: TextAlign.center,
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
        labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 7, 7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color(0xFFEDEDED), // Gris claro
      ),
      cursorColor: const Color(0xFF003366),
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
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF003366)),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedButton() {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: ElevatedButton(
        onPressed: () {
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
          _createAccount();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color.fromARGB(255, 2, 143, 148), // Verde esmeralda
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6.0,
        ),
        child: const Text(
          'Crear Cuenta',
          style: TextStyle(fontSize: 20, letterSpacing: 1.5, color: Color.fromARGB(255, 7, 7, 7)),
        ),
      ),
    );
  }
}
