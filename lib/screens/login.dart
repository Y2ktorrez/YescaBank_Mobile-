import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yescabank/services/loginCustomer_service.dart';
import 'package:yescabank/services/token_storage.dart';
import '../models/login_model.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onSwitchToSignup; // Función para cambiar al registro

  const LoginPage({super.key, required this.onLoginSuccess, required this.onSwitchToSignup});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final LogincustomerService _loginCustomerService = LogincustomerService(); // Instancia del servicio correcta
  TextEditingController _personCodeController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  bool _isLoading = false; // Indicador de carga

  Future<void> _loginCustomer() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
      });

      LoginCustomer loginCustomer = LoginCustomer(
        personCode: _personCodeController.text,
        key: _pinController.text,
      );

      try {
        String? token = await _loginCustomerService.loginCustomer(loginCustomer);

        if (token != null) {
          // Guardar token
          await TokenStorage().saveToken(token);

          // Muestra mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful")),
          );

          // Redirige a la pantalla principal o de perfil
          widget.onLoginSuccess();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed, token not received")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to login: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Método para guardar el token usando SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
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
                  onPressed: _isLoading ? null : _loginCustomer, // Deshabilitar el botón si está cargando
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // Mostrar indicador de carga
                      : const Text("Login", style: TextStyle(fontSize: 16)),
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