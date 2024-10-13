import 'package:flutter/material.dart';
import 'package:yescabank/widgets/action_button.dart';
import 'package:yescabank/widgets/credit_cart.dart';
import 'package:yescabank/widgets/transaction_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 124, 150),
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bienvenido a Yesca Bank",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Andres back!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    IconButton.outlined(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 165),
                      color: Colors.white,
                      child: const Column(
                        children: [
                          SizedBox(height: 110),
                          //Panel Boton de Accion
                          ActionButtons(),
                          SizedBox(height: 30),
                          //Panel de Transacciones
                          TransactionList(),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: 20,
                      left: 25,
                      right: 25,
                      child: CreditCard(),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}