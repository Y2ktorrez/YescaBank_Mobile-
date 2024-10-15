class Customer {
  int ci;
  String name;
  String lastName;
  String email;
  DateTime dateOfBirth;
  String address;
  int phone;
  String ocupation;
  String reference;
  String typeCurencyName; // Cambiado a String
  String typeAccountName; // Cambiado a String

  Customer({
    required this.ci,
    required this.name,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.address,
    required this.phone,
    required this.ocupation,
    required this.reference,
    required this.typeCurencyName,
    required this.typeAccountName,
  });

  Map<String, dynamic> toJson() {
    return {
      'ci': ci,
      'name': name,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'phone': phone,
      'ocupation': ocupation,
      'reference': reference,
      'typeCurencyName': typeCurencyName, // Cambiado a String
      'typeAccountName': typeAccountName, // Cambiado a String
    };
  }
}

