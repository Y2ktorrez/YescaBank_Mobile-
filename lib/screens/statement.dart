import 'package:flutter/material.dart';
import 'package:yescabank/models/transaction_model.dart';
import 'package:yescabank/services/transaction_service.dart';

class StatementScreen extends StatefulWidget {
  final String accountNumber;

  const StatementScreen({super.key, required this.accountNumber});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture =
        TransactionService().getTransactions(widget.accountNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracto de Transacciones'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay transacciones.'));
          }

          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: Icon(transaction.typeTransacctionName == 'Transferencia'
                    ? Icons.swap_horiz
                    : Icons.account_balance),
                title: Text(transaction.description),
                subtitle: Text(
                    'Cuenta origen: ${transaction.accountOrigin}\nCuenta destino: ${transaction.nroAccountDestin}'),
                trailing: Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction.typeTransacctionName == 'Transferencia'
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}