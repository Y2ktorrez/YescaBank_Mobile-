import 'package:flutter/material.dart';
import 'package:yescabank/models/estracto_model.dart';

class StatementList extends StatelessWidget {
  final List<Transaction> transactions;

  const StatementList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction.description),
          subtitle: Text('${transaction.date} ${transaction.hour}'),
          trailing: Text(transaction.isOrigin ? '+${transaction.amount}' : '- ${transaction.amount}'),
        );
      },
    );
  }
}