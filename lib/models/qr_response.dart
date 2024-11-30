class QrResponse {
  final int id;
  final String qrCode;

  QrResponse({required this.id, required this.qrCode});

  factory QrResponse.fromJson(Map<String, dynamic> json) {
    return QrResponse(
      id: json['data']['id'],
      qrCode: json['data']['qrCode'],
    );
  }
}
