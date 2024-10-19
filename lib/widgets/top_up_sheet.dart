import 'package:flutter/material.dart';
import 'package:yescabank/models/transaction_model.dart';
import 'package:yescabank/services/transaction_service.dart';
import 'package:yescabank/screens/home.dart';

class TopUpBottomSheet extends StatefulWidget {
  final String selectedProvider;
  final String account;
  final String image;
  final String accountDestin;
  final String description;
  final bool isTransfer;

  const TopUpBottomSheet({
    super.key,
    required this.selectedProvider,
    required this.account,
    required this.image,
    required this.accountDestin,
    required this.description,
    required this.isTransfer,
  });

  @override
  State<TopUpBottomSheet> createState() => _TopUpBottomSheetState();
}

class _TopUpBottomSheetState extends State<TopUpBottomSheet> {
  double amount = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(widget.image),
              backgroundColor: Colors.white,
            ),
            title: Text(widget.selectedProvider),
            subtitle: Text(widget.account),
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              size: 25,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Colors.black12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Amount",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (amount > 5) amount -= 5;
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              Text(
                "\$ ${amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    amount += 5;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: amount,
            min: 5,
            max: 500,
            activeColor: const Color.fromARGB(255, 16, 80, 98),
            onChanged: (value) {
              setState(() {
                amount = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [5, 10, 15, 20, 50, 100, 200, 500].map((value) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        amount = value.toDouble();
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: amount == value
                            ? const Color.fromARGB(255, 16, 80, 98)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$$value',
                        style: TextStyle(
                          color: amount == value ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: _submitTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                fixedSize: const Size(double.maxFinite, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _submitTransaction() async {
    final transaction = Transaction(
      amount: amount,
      nroAccountDestin: widget.accountDestin,
      description: widget.description,
      accountOrigin: widget.account,
      typeTransacctionName: widget.isTransfer ? "Transferencia" : "Otro",
    );

    try {
      final response = await TransactionService().createTransaction(transaction);
      _showSuccessDialog();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Transferencia Exitosa"),
          content: const Text("La transferencia se ha realizado con éxito."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()),
                ); // Navega al Home
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}