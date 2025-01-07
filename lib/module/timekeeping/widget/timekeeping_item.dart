import 'package:flutter/material.dart';

import '../../../core/theme/app_text_style.dart';

class TimekeepingItem extends StatelessWidget {
  final String date;
  final String checkinTime;
  final String? checkoutTime; // Cho phép null nếu chưa checkout

  const TimekeepingItem({
    super.key,
    required this.date,
    required this.checkinTime,
    this.checkoutTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              // Ngày
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ngày",
                      style: AppTextStyle.s12_regular.copyWith(
                        color: const Color.fromARGB(255, 190, 192, 197),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.s16_medium
                          .copyWith(color: const Color(0xFF08142D)),
                    ),
                  ],
                ),
              ),
              // Check-in
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      "Checkin",
                      style: AppTextStyle.s12_regular.copyWith(
                        color: const Color.fromARGB(255, 190, 192, 197),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      checkinTime,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.s16_medium
                          .copyWith(color: const Color(0xFF08142D)),
                    ),
                  ],
                ),
              ),
              // Check-out
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Checkout",
                      style: AppTextStyle.s12_regular.copyWith(
                        color: const Color.fromARGB(255, 190, 192, 197),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      checkoutTime ??
                          "Chưa checkout", // Hiển thị nếu chưa checkout
                      textAlign: TextAlign.start,
                      style: AppTextStyle.s16_medium
                          .copyWith(color: const Color(0xFF08142D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
