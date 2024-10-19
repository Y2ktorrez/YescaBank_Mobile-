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
  final TextEditingController _accountDestinController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _nroAccount;
  String? _balance;
  String? _typeCurrency;
  bool _isTransferChecked = false;

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
            _buildFormFields(context),
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

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        _buildCustomTextField(
          "Número de Cuenta del a Depositar",
          Icons.person,
          _accountDestinController,
        ),
        const SizedBox(height: 15),
        _buildCheckboxField(),
        const SizedBox(height: 15),
        _buildCustomTextField(
          "Descripción",
          Icons.description,
          _descriptionController,
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopUpPage(
                  accountDestin: _accountDestinController.text,
                  description: _descriptionController.text,
                  isTransfer: _isTransferChecked,
                ),
              ),
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

  Widget _buildCustomTextField(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          prefixIcon: Icon(icon, size: 28, color: Colors.grey[600]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildCheckboxField() {
    return Container(
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _isTransferChecked,
            onChanged: (value) {
              setState(() {
                _isTransferChecked = value ?? false;
              });
            },
          ),
          const Text(
            "Transferencia",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}