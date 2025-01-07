import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_text_style.dart';
import '../model/take_list_model.dart';

extension DateTimeFormatting on DateTime {
  // Định dạng dd/MM/yyyy
  String toDateFormat() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  // Định dạng hh:mm dd/MM/yyyy
  String toDateTimeFormat() {
    return DateFormat('HH:mm dd/MM/yyyy').format(this);
  }
}

class TakeListItem extends StatelessWidget {
  const TakeListItem({super.key, required this.item});

  final TakeListModel item;

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
              Expanded(
                child: Text(
                  "Đơn xin nghỉ",
                  style: AppTextStyle.s18_medium
                      .copyWith(color: const Color(0xFF08142D)),
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.menu))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ngày bắt đầu xin nghỉ",
                      style: AppTextStyle.s12_regular.copyWith(
                          color: const Color.fromARGB(255, 190, 192, 197)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.startDate.toDateFormat(),
                      textAlign: TextAlign.start,
                      style: AppTextStyle.s16_medium
                          .copyWith(color: const Color(0xFF08142D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      "Số ngày nghỉ",
                      style: AppTextStyle.s12_regular.copyWith(
                          color: const Color.fromARGB(255, 190, 192, 197)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.endDate.difference(item.startDate).inDays.toString(),
                      textAlign: TextAlign.start,
                      style: AppTextStyle.s16_medium
                          .copyWith(color: const Color(0xFF08142D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Lý do",
                      style: AppTextStyle.s12_regular.copyWith(
                          color: const Color.fromARGB(255, 190, 192, 197)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.reason,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.s16_medium
                          .copyWith(color: const Color(0xFF08142D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.createdAt?.toDateTimeFormat() ?? "15:30 07/08/2024",
                  style: AppTextStyle.s16_regular.copyWith(
                      color: const Color.fromARGB(255, 190, 192, 197)),
                ),
              ),
              Icon(
                item.status?.toLowerCase() == 'pending'
                    ? Icons.lock_clock
                    : Icons.done_outlined,
                color: item.status?.toLowerCase() == 'pending'
                    ? const Color.fromARGB(255, 222, 227, 65)
                    : const Color.fromARGB(255, 48, 182, 90),
              ),
              const SizedBox(width: 4),
              Text(
                item.status ?? '',
                style: AppTextStyle.s16_medium.copyWith(
                    color: item.status?.toLowerCase() == 'pending'
                        ? const Color.fromARGB(255, 222, 227, 65)
                        : const Color.fromARGB(255, 48, 182, 90)),
              )
            ],
          )
        ],
      ),
    );
  }
}
