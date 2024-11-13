// lib/screens/interest_simulation_screen.dart
import 'package:flutter/material.dart';
import '../services/interest_service.dart';
import '../models/interest_simulation_model.dart';

class InterestSimulationScreen extends StatefulWidget {
  @override
  _InterestSimulationScreenState createState() => _InterestSimulationScreenState();
}

class _InterestSimulationScreenState extends State<InterestSimulationScreen> {
  final _initialAmountController = TextEditingController();
  final _termController = TextEditingController();
  final _interestRateController = TextEditingController();
  InterestSimulation? _simulationResult;
  final InterestService _interestService = InterestService();

  void _simulateInterest() {
    double initialAmount = double.parse(_initialAmountController.text);
    int termInMonths = int.parse(_termController.text);
    double interestRate = double.parse(_interestRateController.text);

    setState(() {
      _simulationResult = _interestService.calculateInterest(
        initialAmount: initialAmount,
        termInMonths: termInMonths,
        interestRate: interestRate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simulación de Intereses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 124, 150),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calcula tu interés:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 124, 150),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _initialAmountController,
              label: 'Monto inicial (\$)',
            ),
            SizedBox(height: 15),
            _buildTextField(
              controller: _termController,
              label: 'Plazo (en meses)',
            ),
            SizedBox(height: 15),
            _buildTextField(
              controller: _interestRateController,
              label: 'Tasa de interés (%)',
            ),
            SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: _simulateInterest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 124, 150),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Simular Intereses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (_simulationResult != null) _buildSimulationSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 5, 124, 150)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color.fromARGB(255, 5, 124, 150)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color.fromARGB(255, 5, 124, 150), width: 2),
        ),
      ),
      style: TextStyle(color: Color.fromARGB(255, 5, 124, 150)),
    );
  }

  Widget _buildSimulationSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen de la Simulación',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 5, 124, 150),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 230, 247, 255),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryText('Monto Inicial:', '\$${_simulationResult!.initialAmount.toStringAsFixed(2)}'),
              _buildSummaryText('Plazo:', '${_simulationResult!.termInMonths} meses'),
              _buildSummaryText('Tasa de Interés:', '${_simulationResult!.interestRate}%'),
              Divider(color: Colors.grey.shade400),
              _buildSummaryText('Interés Total:', '\$${_simulationResult!.totalInterest.toStringAsFixed(2)}'),
              _buildSummaryText('Monto Final:', '\$${_simulationResult!.finalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
