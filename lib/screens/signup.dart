import 'package:flutter/material.dart';
import '../models/createCustomer_model.dart';
import '../services/customer_service.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  final VoidCallback onSwitchToLogin; // Función para cambiar al login

  const SignupPage({super.key, required this.onSignupSuccess, required this.onSwitchToLogin});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final CustomerService _customerService = CustomerService(); // Instancia del servicio

  // Controladores para los campos del formulario
  TextEditingController _ciController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ocupationController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _typeCurrencyController = TextEditingController();
  TextEditingController _typeAccountController = TextEditingController();

  // Método para registrar el cliente
  Future<void> _registerCustomer() async {
    if (formKey.currentState!.validate()) {
      Customer newCustomer = Customer(
        ci: _ciController.text,
        name: _nameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        dateOfBirth: _dateOfBirthController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        ocupation: _ocupationController.text,
        reference: _referenceController.text,
        typeCurrencyId: int.parse(_typeCurrencyController.text),
        typeAccountId: int.parse(_typeAccountController.text),
      );

      try {
        await _customerService.createCustomer(newCustomer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Customer created successfully")),
        );
        widget.onSignupSuccess(); // Usuario registrado exitosamente
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create customer: $e")),
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
                    const Text("Sign Up", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
                    const Text("Create a new account and get started"),
                    const SizedBox(height: 10),

                    // Campo CI
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "CI cannot be empty." : null,
                      controller: _ciController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("CI"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Nombre
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Name cannot be empty." : null,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Name"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Apellido
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Last Name cannot be empty." : null,
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Last Name"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Email
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Email cannot be empty." : null,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Fecha de Nacimiento
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Date of Birth cannot be empty." : null,
                      controller: _dateOfBirthController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Date of Birth (YYYY-MM-DD)"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Dirección
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Address cannot be empty." : null,
                      controller: _addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Address"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Teléfono
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Phone cannot be empty." : null,
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Phone"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Ocupación
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Occupation cannot be empty." : null,
                      controller: _ocupationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Occupation"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Referencia
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Reference cannot be empty." : null,
                      controller: _referenceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Reference"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Tipo de Moneda (ID)
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Type Currency ID cannot be empty." : null,
                      controller: _typeCurrencyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Type Currency ID"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Tipo de Cuenta (ID)
                    TextFormField(
                      validator: (value) => value!.isEmpty ? "Type Account ID cannot be empty." : null,
                      controller: _typeAccountController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Type Account ID"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Botón de Registrar
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: _registerCustomer, // Llamada al método para registrar cliente
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),

              // Cambiar a Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: widget.onSwitchToLogin, // Cambiamos de vuelta al login
                    child: const Text("Login"),
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