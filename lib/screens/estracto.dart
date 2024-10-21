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
  late Future<List<Transaction>> futureTransactions;
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    futureTransactions = _transactionService.fetchTransactions(widget.accountNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Extractos"),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: futureTransactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay extractos disponibles'));
          }

          return StatementList(transactions: snapshot.data!);
        },
      ),
    );
  }
}