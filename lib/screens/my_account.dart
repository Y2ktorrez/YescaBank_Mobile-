import 'package:flutter/material.dart';
import 'package:yescabank/services/customer_service_B.dart';
import 'package:yescabank/screens/add_account.dart'; // Importar la nueva pantalla

class MyCardPage extends StatefulWidget {
  const MyCardPage({super.key});

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  final CustomerServiceB _customerServiceB = CustomerServiceB();
  String? _customerName;
  String? _nroAccount;
  bool _isLoading = true;

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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _customerName = 'Error al cargar nombre';
        _nroAccount = '****';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Account",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    BackCard(
                      nroAccount: _nroAccount ?? '****',
                      customerName: _customerName ?? 'Nombre',
                    ),
                    const SizedBox(height: 25),
                    const SizedBox(height: 30),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAccountPage(), // Navegar a la nueva pantalla
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add new Account",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[100]!),
                        fixedSize: const Size(double.maxFinite, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class BackCard extends StatefulWidget {
  final String nroAccount;
  final String customerName;

  const BackCard({
    super.key,
    required this.nroAccount,
    required this.customerName,
  });

  @override
  _BackCardState createState() => _BackCardState();
}

class _BackCardState extends State<BackCard> {
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    String maskedAccountNumber = _isHidden
        ? '*********${widget.nroAccount.substring(widget.nroAccount.length - 4)}'
        : widget.nroAccount;

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 14, 19, 29),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              "assets/card.png",
              fit: BoxFit.cover,
              width: 160,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white.withOpacity(0.8),
                    ),
                    Transform.translate(
                      offset: const Offset(-10, 0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      maskedAccountNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: _toggleVisibility,
                    ),
                  ],
                ),
                Text(
                  widget.customerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}