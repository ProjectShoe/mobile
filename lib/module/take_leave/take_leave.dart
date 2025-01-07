import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/module/take_leave_list/widget/take_list_item.dart';

import '../../core/constants/resources.dart';
import '../../core/theme/app_color_style.dart';
import '../../core/theme/app_text_style.dart';
import '../take_leave_list/model/take_list_model.dart';
import 'bloc/take_leave_bloc.dart';
import 'bloc/take_leave_state.dart';

class TakeLeaveScreen extends StatefulWidget {
  const TakeLeaveScreen({super.key});

  @override
  State<TakeLeaveScreen> createState() => _TakeLeaveScreenState();
}

class _TakeLeaveScreenState extends State<TakeLeaveScreen> {
  // String? _reason;

  DateTime _selectedDate = DateTime.now();
  final _numController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _numController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TakeLeaveCubit(),
      child: BlocListener<TakeLeaveCubit, TakeLeaveState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess,
        listener: (context, state) {
          if (state.isSuccess) context.pop(true);
        },
        child: BlocBuilder<TakeLeaveCubit, TakeLeaveState>(
          builder: (context, state) {
            final cubit = context.read<TakeLeaveCubit>();
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      IconPath.arrowLeft,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                title: Text(
                  "Lập đơn xin nghỉ phép",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s20_bold
                      .copyWith(color: const Color(0xFF08142D)),
                ),
                centerTitle: true,
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lý do",
                          style: AppTextStyle.s16_regular
                              .copyWith(color: const Color(0xFF08142D)),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _reasonController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 6, left: 12),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            hintText: 'Nhập lý do xin nghỉ...',
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 19.6 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                color: Colors.black),
                          ),
                          cursorColor: Colors.black,
                          cursorHeight: 20,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ngày bắt đầu xin nghỉ",
                                    style: AppTextStyle.s16_regular.copyWith(
                                        color: const Color(0xFF08142D)),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.datetime,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(top: 6, left: 12),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      hintText: _selectedDate.toDateFormat(),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 19.6 / 14,
                                          leadingDistribution:
                                              TextLeadingDistribution.even,
                                          color: Colors.black),
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            setState(() {
                                              _selectedDate = date;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.calendar_month),
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                    cursorHeight: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số ngày nghỉ",
                                    style: AppTextStyle.s16_regular.copyWith(
                                        color: const Color(0xFF08142D)),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _numController,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(top: 6, left: 12),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      hintText: 'Nhập số ngày nghỉ',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 19.6 / 14,
                                          leadingDistribution:
                                              TextLeadingDistribution.even,
                                          color: Colors.black),
                                    ),
                                    cursorColor: Colors.black,
                                    cursorHeight: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Text(
                        //   "Hình thức nghỉ",
                        //   style: AppTextStyle.s16_regular
                        //       .copyWith(color: const Color(0xFF08142D)),
                        // ),
                        // const SizedBox(height: 8),
                        // Row(
                        //   children: [
                        //     Radio<String>(
                        //       value: 'Nghỉ phép',
                        //       groupValue: _reason,
                        //       onChanged: (String? value) {
                        //         setState(() {
                        //           _reason = value;
                        //         });
                        //       },
                        //     ),
                        //     Text(
                        //       'Nghỉ phép',
                        //       style: AppTextStyle.s16_regular
                        //           .copyWith(color: const Color(0xFF08142D)),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 8),
                        // Row(
                        //   children: [
                        //     Radio<String>(
                        //       value: 'Nghỉ không lương',
                        //       groupValue: _reason,
                        //       onChanged: (String? value) {
                        //         setState(() {
                        //           _reason = value;
                        //         });
                        //       },
                        //     ),
                        //     Text(
                        //       'Nghỉ không lương',
                        //       style: AppTextStyle.s16_regular
                        //           .copyWith(color: const Color(0xFF08142D)),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 8),
                        // Row(
                        //   children: [
                        //     Radio<String>(
                        //       value: 'Nghỉ hiếu',
                        //       groupValue: _reason,
                        //       onChanged: (String? value) {
                        //         setState(() {
                        //           _reason = value;
                        //         });
                        //       },
                        //     ),
                        //     Text(
                        //       'Nghỉ hiếu',
                        //       style: AppTextStyle.s16_regular
                        //           .copyWith(color: const Color(0xFF08142D)),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 8),
                        // Row(
                        //   children: [
                        //     Radio<String>(
                        //       value: 'Nghỉ hỷ',
                        //       groupValue: _reason,
                        //       onChanged: (String? value) {
                        //         setState(() {
                        //           _reason = value;
                        //         });
                        //       },
                        //     ),
                        //     Text(
                        //       'Nghỉ hỷ',
                        //       style: AppTextStyle.s16_regular
                        //           .copyWith(color: const Color(0xFF08142D)),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                ],
              ),
              bottomNavigationBar: Container(
                margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColorStyle.grey_2,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            "Hủy",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.s18_medium
                                .copyWith(color: const Color(0xFF08142D)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (_numController.text.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Bạn phải nhập số ngày nghỉ");
                            return;
                          }
                          if (_reasonController.text.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Bạn phải nhập lý do nghỉ");
                            return;
                          }
                          cubit.addTakeLeave(TakeListModel(
                            startDate: _selectedDate,
                            endDate: _selectedDate.add(Duration(
                                days: int.tryParse(_numController.text) ?? 0)),
                            reason: _reasonController.text,
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColorStyle.grey_2,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            "Thêm",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.s18_medium
                                .copyWith(color: const Color(0xFF08142D)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
