// lib/services/interest_service.dart
import '../models/interest_simulation_model.dart';

class InterestService {
  InterestSimulation calculateInterest({
    required double initialAmount,
    required int termInMonths,
    required double interestRate,
  }) {
    // Calcular el interés total
    double totalInterest = initialAmount * (interestRate / 100) * (termInMonths / 12);
    // Calcular el monto final
    double finalAmount = initialAmount + totalInterest;

    return InterestSimulation(
      initialAmount: initialAmount,
      termInMonths: termInMonths,
      interestRate: interestRate,
      totalInterest: totalInterest,
      finalAmount: finalAmount,
    );
  }
}
