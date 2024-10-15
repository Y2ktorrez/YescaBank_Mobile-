class Customer {
  String ci;
  String name;
  String lastName;
  String email;
  String dateOfBirth;
  String address;
  String phone;
  String ocupation;
  String reference;
  int typeCurrencyId;
  int typeAccountId;

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
    required this.typeCurrencyId,
    required this.typeAccountId,
  });

  Map<String, dynamic> toJson() {
    return {
      'ci': ci,
      'name': name,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'phone': phone,
      'ocupation': ocupation,
      'reference': reference,
      'typeCurrency_id': typeCurrencyId,
      'typeAccount_id': typeAccountId,
    };
  }
}
