  import 'package:flutter/material.dart';
  import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
  import 'package:yescabank/services/customer_service_B.dart';
  import 'package:yescabank/widgets/top_up_sheet.dart';

  class TopUpPage extends StatefulWidget {
    final String accountDestin;
    final String description;
    final bool isTransfer;

    const TopUpPage({
      super.key,
      required this.accountDestin,
      required this.description,
      required this.isTransfer,
    });

    @override
    State<TopUpPage> createState() => _TopUpPageState();
  }

  class _TopUpPageState extends State<TopUpPage> {
    String selectedProvider = 'Bank Of America';
    List<String> accounts = [];

    @override
    void initState() {
      super.initState();
      _loadCustomerAccounts();
    }

    Future<void> _loadCustomerAccounts() async {
      final customerService = CustomerServiceB();
      try {
        final customerData = await customerService.getCustomerData();
        setState(() {
          accounts.add(customerData.nroAccount);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar cuentas del cliente: $e')),
        );
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
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bank Transfer",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ..._buildAccountWidgets(),
              const Text(
                "Other",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              _buildPaymentProvider("assets/paypal.jpg", "Paypal", "Easy payment"),
              _buildPaymentProvider("assets/apple.png", "Apple pay", "Easy payment"),
              _buildPaymentProvider("assets/google.png", "Google pay", "Easy payment"),
              ElevatedButton(
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => TopUpBottomSheet(
                      selectedProvider: selectedProvider,
                      image: getImageForProvider(selectedProvider),
                      account: getAccountForProvider(selectedProvider),
                      accountDestin: widget.accountDestin,
                      description: widget.description,
                      isTransfer: widget.isTransfer,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(double.maxFinite, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
    }

    List<Widget> _buildAccountWidgets() {
      return accounts.map((account) {
        return PaymentProvider(
          image: "assets/bank_of_america.jpg",
          name: "Bank Of America",
          account: account,
          isSelected: selectedProvider == 'Bank Of America',
          onChanged: (value) {
            if (value == true) {
              setState(() {
                selectedProvider = 'Bank Of America';
              });
            }
          },
        );
      }).toList();
    }

    Widget _buildPaymentProvider(String image, String name, String account) {
      return PaymentProvider(
        image: image,
        name: name,
        account: account,
        isSelected: selectedProvider == name,
        onChanged: (value) {
          if (value == true) {
            setState(() {
              selectedProvider = name;
            });
          }
        },
      );
    }

    String getAccountForProvider(String provider) {
      if (provider == 'Bank Of America' && accounts.isNotEmpty) {
        return accounts[0];
      }
      return 'Easy Payment';
    }

    String getImageForProvider(String provider) {
      switch (provider) {
        case 'Bank Of America':
          return 'assets/bank_of_america.jpg';
        case 'U.S Bank':
          return 'assets/us_bank.png';
        case 'Paypal':
          return 'assets/paypal.jpg';
        case 'Apple pay':
          return 'assets/apple.png';
        case 'Google pay':
          return 'assets/google.png';
        default:
          return 'assets/default.png';
      }
    }
  }

  class PaymentProvider extends StatelessWidget {
    const PaymentProvider({
      super.key,
      required this.image,
      required this.name,
      required this.account,
      required this.isSelected,
      required this.onChanged,
    });

    final String image;
    final String name;
    final String account;
    final bool isSelected;
    final ValueChanged<bool?> onChanged;

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(image),
              backgroundColor: Colors.white,
            ),
            title: Text(name),
            subtitle: Text(account),
            trailing: Transform.scale(
              scale: 1.5,
              child: Radio.adaptive(
                value: true,
                groupValue: isSelected,
                onChanged: onChanged,
                activeColor: const Color.fromARGB(255, 16, 80, 98),
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }
  }