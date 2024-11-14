import 'package:flutter/material.dart';
import 'package:yescabank/services/account_service2.dart';
import 'package:yescabank/widgets/account_charts.dart';
import 'package:yescabank/models/account_activity.dart';

class AccountActivityScreen extends StatefulWidget {
  const AccountActivityScreen({super.key});

  @override
  _AccountActivityScreenState createState() => _AccountActivityScreenState();
}

class _AccountActivityScreenState extends State<AccountActivityScreen> {
  final AccountService _accountService = AccountService();
  late Future<List<AccountActivity>> _accountActivityFuture;

  @override
  void initState() {
    super.initState();
    _accountActivityFuture = _accountService.getAccountActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Actividad de Cuenta", style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<AccountActivity>>(
          future: _accountActivityFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No hay actividad en la cuenta",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            } else {
              return AccountCharts(activityList: snapshot.data!);
            }
          },
        ),
      ),
    );
  }
}
