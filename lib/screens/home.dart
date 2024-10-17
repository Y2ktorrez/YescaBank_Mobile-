import 'package:flutter/material.dart';
import 'package:yescabank/widgets/action_button.dart';
import 'package:yescabank/widgets/credit_cart.dart'; // Corregido el nombre del archivo
import 'package:yescabank/widgets/transaction_list.dart';
import 'package:yescabank/services/customer_service_B.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CustomerServiceB _customerServiceB = CustomerServiceB();
  String? _customerName;
  String? _nroAccount;
  String? _balance;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    try {
      final customerData = await _customerServiceB.getCustomerData();
      setState(() {
        _customerName = '${customerData.name} ${customerData.lastName}'; // Actualiza el estado con el nombre del cliente
        _nroAccount = customerData.nroAccount; // Actualiza el número de cuenta
        _balance = customerData.balance; // Actualiza el balance
      });
    } catch (e) {
      // Manejo de errores
      setState(() {
        _customerName = 'Error al cargar nombre'; // Mensaje de error
        _nroAccount = 'Error'; // Mensaje de error
        _balance = '0.00'; // Mensaje de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 124, 150),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bienvenido a Yesca Bank",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        _customerName != null ? '$_customerName back!' : 'Cargando...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 165),
                    color: Colors.white,
                    child: const Column(
                      children: [
                        SizedBox(height: 110),
                        // Panel Boton de Acción
                        ActionButtons(),
                        SizedBox(height: 30),
                        // Panel de Transacciones
                        TransactionList(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 25,
                    right: 25,
                    child: CreditCard(
                      nroAccount: _nroAccount ?? '****', // Pasa el número de cuenta
                      balance: _balance ?? '0.00', // Pasa el balance
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}