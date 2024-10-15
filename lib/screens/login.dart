import 'package:flutter/material.dart';

import '../models/login_model.dart';
import '../services/customer_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onSwitchToSignup; // Función para cambiar al registro

  const LoginPage({super.key, required this.onLoginSuccess, required this.onSwitchToSignup});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final CustomerService _customerService = CustomerService(); // Instancia del servicio
  TextEditingController _personCodeController = TextEditingController();
  TextEditingController _pinController = TextEditingController();

  // Método para hacer login del cliente
  Future<void> _loginCustomer() async {
    if (formKey.currentState!.validate()) {
      LoginCustomer loginCustomer = LoginCustomer(
        personCode: _personCodeController.text,
        key: _pinController.text,
      );

      try {
        String? token = await _customerService.loginCustomer(loginCustomer);
        if (token != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful")),
          );
          widget.onLoginSuccess(); // Usuario autenticado exitosamente
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to login: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Login", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
                    const Text("Get started with your account"),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) => value!.isEmpty ? "Código Persona cannot be empty." : null,
                        controller: _personCodeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Código Persona"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 4 ? "Pin should have at least 4 characters." : null,
                  controller: _pinController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Pin"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: _loginCustomer, // Llamada al método para hacer login
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: widget.onSwitchToSignup, // Cambiamos al registro
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}