class LoginCustomer {
  String personCode;
  String key;

  LoginCustomer({required this.personCode, required this.key});

  Map<String, dynamic> toJson() {
    return {
      'personCode': personCode,
      'key': key,
    };
  }
}

