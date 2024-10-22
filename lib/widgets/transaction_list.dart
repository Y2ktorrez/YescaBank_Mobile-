import 'package:flutter/material.dart';
import 'package:yescabank/models/transaction_model.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isNegative = transaction.amount < 0;

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 239, 243, 245),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: isNegative ? Colors.red : Colors.green,
                  ),
                ),
                title: Text(transaction.description),
                subtitle: Text(transaction.typeTransacctionName),
                trailing: Text(
                  "${isNegative ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(color: isNegative ? Colors.red : Colors.green),
                ),
              ),
              Divider(color: Colors.grey[200]),
            ],
          );
        },
      ),
    );
  }
}