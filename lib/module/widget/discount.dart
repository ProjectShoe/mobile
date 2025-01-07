import 'package:flutter/material.dart';

class Discount extends StatelessWidget {
  const Discount({
    super.key,
    required this.discount,
  });

  final String? discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromRGBO(206, 160, 107, 1)),
      child: Text(
        "SL: $discount",
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
