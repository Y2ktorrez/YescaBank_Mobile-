import 'package:flutter/material.dart';
import 'package:yescabank/widgets/action_button.dart';
import 'package:yescabank/widgets/credit_cart.dart';
import 'package:yescabank/widgets/transaction_list.dart';
import 'package:yescabank/services/customer_service_B.dart';
import 'package:yescabank/services/transaction_service.dart';
import 'package:yescabank/models/transaction_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CustomerServiceB _customerServiceB = CustomerServiceB();
  final TransactionService _transactionService = TransactionService();
  String? _customerName;
  String? _nroAccount;
  String? _balance;
  String? _typeCurrency;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    try {
      final customerData = await _customerServiceB.getCustomerData();
      setState(() {
        _customerName = '${customerData.name} ${customerData.lastName}';
        _nroAccount = customerData.nroAccount;
        _balance = customerData.balance;
        _typeCurrency = customerData.typeCurrency;
      });

      // Cargar transacciones una vez que tengamos el número de cuenta
      await _loadTransactions(customerData.nroAccount);
    } catch (e) {
      setState(() {
        _customerName = 'Error al cargar nombre';
        _nroAccount = 'Error';
        _balance = '0.00';
        _typeCurrency = 'N/A';
      });
    }
  }

  Future<void> _loadTransactions(String nroAccount) async {
    try {
      final transactions = await _transactionService.getTransactions(nroAccount);
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      print('Error al cargar las transacciones: $e');
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
                        _customerName ?? 'Cargando...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                    child: Column(
                      children: [
                        const SizedBox(height: 110),
                        const ActionButtons(),
                        const SizedBox(height: 30),
                        TransactionList(transactions: _transactions),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 25,
                    right: 25,
                    child: CreditCard(
                      nroAccount: _nroAccount ?? '****',
                      balance: _balance ?? '0.00',
                      typeCurrency: _typeCurrency ?? 'N/A',
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