import 'package:flutter/material.dart';
import 'package:yescabank/services/customer_service_B.dart';
import 'package:yescabank/services/token_storage.dart';
import '../main.dart';

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
    await tokenStorage.deleteToken(); // Elimina el token guardado

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false, // Elimina todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 124, 150),
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
              backgroundColor: Colors.grey[200],
              child: const Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${_customerData!.name} ${_customerData!.lastName}',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Número de Cuenta: ${_customerData!.nroAccount}',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Saldo: ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Text(
                  '${_customerData!.balance} ${_customerData!.typeCurrency}',
                  style: const TextStyle(
                      fontSize: 18, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Tipo de Cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_customerData!.typeAccount),
            ),
            ListTile(
              title: const Text('Estado de la Cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_customerData!.state),
            ),
            ListTile(
              title: const Text('Creado el',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_customerData!.createAt),
            ),
            ListTile(
              title: const Text('Última Actualización',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_customerData!.updateAt),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black, // Texto en negro
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15),
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