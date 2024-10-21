import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCard extends StatefulWidget {
  final String nroAccount;
  final String balance;
  final String typeCurrency;

  const CreditCard({
    super.key,
    required this.nroAccount,
    required this.balance,
    required this.typeCurrency,
  });

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  bool _isAccountHidden = true;
  bool _isBalanceHidden = true;

  void _toggleAccountVisibility() {
    setState(() {
      _isAccountHidden = !_isAccountHidden;
    });
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceHidden = !_isBalanceHidden;
    });
  }

  // Función para copiar el número de cuenta al portapapeles
  void _copyAccountNumber() {
    Clipboard.setData(ClipboardData(text: widget.nroAccount));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Número de cuenta copiado'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String fullAccountNumber = _isAccountHidden
        ? '*********${widget.nroAccount.substring(widget.nroAccount.length - 4)}'
        : widget.nroAccount;

    String displayedBalance =
    _isBalanceHidden ? '' : '${widget.balance} ${widget.typeCurrency}';

    return Container(
      height: 220,
      width: 350,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Parte superior de la tarjeta
            Expanded(
              flex: 2,
              child: Container(
                color: const Color.fromARGB(255, 14, 19, 29),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Image.asset(
                        "assets/credit-card.png",
                        height: 40,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 70,
                      child: Image.asset(
                        "assets/wifi.png",
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Row(
                        children: [
                          Text(
                            fullAccountNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              _isAccountHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: _toggleAccountVisibility,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                            onPressed: _copyAccountNumber,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 5, 124, 150),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            displayedBalance,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              _isBalanceHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: _toggleBalanceVisibility,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}