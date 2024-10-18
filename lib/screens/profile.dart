import 'package:flutter/material.dart';
import 'package:yescabank/services/customer_service_B.dart';
import 'package:yescabank/services/token_storage.dart';
import 'package:yescabank/screens/login.dart'; // Asegúrate de que este archivo contenga LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CustomerData? _customerData;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    final customerService = CustomerServiceB();
    try {
      final customerData = await customerService.getCustomerData();
      setState(() {
        _customerData = customerData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos del cliente: $e')),
      );
    }
  }

  Future<void> _logout() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.deleteToken(); // Asegúrate de que esta función esté implementada
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onLoginSuccess: _onLoginSuccess,
          onSwitchToSignup: _onSwitchToSignup,
        ),
      ),
    );
  }

  void _onLoginSuccess() {
    // Aquí puedes manejar la lógica después de un inicio de sesión exitoso
    // Por ejemplo, redirigir a la pantalla principal
  }

  void _onSwitchToSignup() {
    // Aquí puedes manejar la lógica para cambiar a la pantalla de registro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil del Cliente',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 16, 80, 98),
        centerTitle: true,
        elevation: 4,
      ),
      body: _customerData != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const NetworkImage(
                      'https://i.ibb.co/GkRvkhT/Captura-de-pantalla-2024-10-18-022526.png',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${_customerData!.name} ${_customerData!.lastName}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Número de Cuenta: ${_customerData!.nroAccount}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Saldo: ${_customerData!.balance} ${_customerData!.typeCurrency}',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Tipo de Cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_customerData!.typeAccount),
                  ),
                  ListTile(
                    title: const Text('Estado de la Cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_customerData!.state),
                  ),
                  ListTile(
                    title: const Text('Creado el', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_customerData!.createAt),
                  ),
                  ListTile(
                    title: const Text('Última Actualización', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_customerData!.updateAt),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}