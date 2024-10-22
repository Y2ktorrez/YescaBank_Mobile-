import 'package:flutter/material.dart';
import 'package:yescabank/services/estracto_service.dart';
import 'package:yescabank/models/estracto_model.dart';
import 'package:yescabank/widgets/estracto_list.dart';

class StatementScreen extends StatefulWidget {
  final String accountNumber;

  const StatementScreen({super.key, required this.accountNumber});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  late Future<Transaction> futureTransaction; // Cambiado a Future<Transaction>
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    futureTransaction = _transactionService.fetchTransaction(widget.accountNumber); // Cambiado a fetchTransaction
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Extractos"),
      ),
      body: FutureBuilder<Transaction>(
        future: futureTransaction,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No hay extractos disponibles'));
          }

          // Aquí puedes crear una lista con un solo elemento o mostrar los detalles de la transacción
          return StatementList(transactions: [snapshot.data!]); // Envolviendo en una lista
        },
      ),
    );
  }
}