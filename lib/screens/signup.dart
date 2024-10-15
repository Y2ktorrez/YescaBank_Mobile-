import 'package:flutter/material.dart';
import '../models/createCustomer_model.dart';
import '../services/customer_service.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  final VoidCallback onSwitchToLogin;

  const SignupPage({super.key, required this.onSignupSuccess, required this.onSwitchToLogin});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final CustomerService _customerService = CustomerService();

  // Controladores para los campos del formulario
  TextEditingController _ciController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ocupationController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  DateTime? _selectedDate; // Variable para la fecha seleccionada
  String _selectedCurrency = "USD"; // Moneda predeterminada
  String _selectedAccountType = "Cuenta Corriente"; // Tipo de cuenta predeterminada

  // Método para registrar el cliente
  Future<void> _registerCustomer() async {
    if (formKey.currentState!.validate()) {
      Customer newCustomer = Customer(
        ci: int.parse(_ciController.text),
        name: _nameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        dateOfBirth: _selectedDate!,
        address: _addressController.text,
        phone: int.parse(_phoneController.text),
        ocupation: _ocupationController.text,
        reference: _referenceController.text,
        typeCurencyName: _selectedCurrency, // Moneda seleccionada
        typeAccountName: _selectedAccountType, // Tipo de cuenta seleccionada
      );

      try {
        await _customerService.createCustomer(newCustomer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Customer created successfully")),
        );
        widget.onSignupSuccess();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create customer: $e")),
        );
      }
    }
  }

  // Método para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onSwitchToLogin,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Create a new account and get started",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      // Campo CI
                      TextFormField(
                        validator: (value) => value!.isEmpty ? "CI cannot be empty." : null,
                        controller: _ciController,
                        keyboardType: TextInputType.number,
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

                      // Selector de Fecha de Nacimiento
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _selectedDate == null
                                  ? 'Select Date of Birth'
                                  : "${_selectedDate!.toLocal()}".split(' ')[0],
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Date of Birth"),
                            ),
                            validator: (value) => _selectedDate == null
                                ? "Please select a date of birth."
                                : null,
                          ),
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
                        keyboardType: TextInputType.number,
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

                      // Selector de tipo de moneda
                      const Text("Select Currency Type"),
                      RadioListTile<String>(
                        title: const Text("USD"),
                        value: "USD",
                        groupValue: _selectedCurrency,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("EUR"),
                        value: "EUR",
                        groupValue: _selectedCurrency,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("BOB"),
                        value: "BOB",
                        groupValue: _selectedCurrency,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value!;
                          });
                        },
                      ),

                      // Selector de tipo de cuenta
                      const Text("Select Account Type"),
                      RadioListTile<String>(
                        title: const Text("Cuenta Corriente"),
                        value: "Cuenta Corriente",
                        groupValue: _selectedAccountType,
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountType = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Cuenta de Ahorro"),
                        value: "Cuenta de Ahorro",
                        groupValue: _selectedAccountType,
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Botón de Registrar
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .85,
                  child: ElevatedButton(
                    onPressed: _registerCustomer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 10),

                // Botón para volver al login
                TextButton(
                  onPressed: widget.onSwitchToLogin,
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}