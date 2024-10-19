import 'package:flutter/material.dart';
import 'package:yescabank/screens/top_up.dart';
import 'package:yescabank/services/customer_service_B.dart';
import 'package:yescabank/widgets/credit_cart.dart';

class TransferMoney extends StatefulWidget {
  const TransferMoney({super.key});

  @override
  State<TransferMoney> createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  final CustomerServiceB _customerServiceB = CustomerServiceB();
  String? _nroAccount;
  String? _balance;
  String? _typeCurrency;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    try {
      final customerData = await _customerServiceB.getCustomerData();
      setState(() {
        _nroAccount = customerData.nroAccount;
        _balance = customerData.balance;
        _typeCurrency = customerData.typeCurrency;
      });
    } catch (e) {
      setState(() {
        _nroAccount = '****';
        _balance = '0.00';
        _typeCurrency = 'N/A';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton.outlined(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Transfer"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCreditCardsSection(),
            const SizedBox(height: 25),
            _buildRecipientsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Account",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: CreditCard(
                  nroAccount: _nroAccount ?? '****',
                  balance: _balance ?? '0.00',
                  typeCurrency: _typeCurrency ?? 'N/A',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose recipients",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        Container(
          width: double.infinity,
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search contacts...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 25),
        _buildRecipientList(),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TopUpPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            fixedSize: const Size(double.maxFinite, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 130,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: index == 0 ? Colors.teal : Colors.grey,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index == 0
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.check, color: Colors.teal),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/person.jpeg"),
                  ),
                  const Text(
                    "Maria",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Sevchenko",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
