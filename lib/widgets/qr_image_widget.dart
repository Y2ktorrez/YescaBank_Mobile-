import 'dart:convert';
import 'package:flutter/material.dart';

class QrImageWidget extends StatelessWidget {
  final String base64String;

  const QrImageWidget({super.key, required this.base64String});

  @override
  Widget build(BuildContext context) {
    final decodedBytes = base64Decode(base64String.split(',')[1]);
    return Image.memory(decodedBytes);
  }
}
