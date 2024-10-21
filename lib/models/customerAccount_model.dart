class CustomerAccount {
  int ci; // Identificación del cliente
  String typeCurencyName; // Nombre del tipo de moneda
  String typeAccountName; // Nombre del tipo de cuenta
  String contratEmail; // Correo electrónico del contrato

  CustomerAccount({
    required this.ci,
    required this.typeCurencyName,
    required this.typeAccountName,
    required this.contratEmail,
  });

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'ci': ci,
      'typeCurencyName': typeCurencyName,
      'typeAccountName': typeAccountName,
      'contratEmail': contratEmail,
    };
  }
}