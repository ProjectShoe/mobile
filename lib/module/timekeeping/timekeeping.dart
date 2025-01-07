import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoes_store/core/constants/secure_storage.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';

import '../../core/theme/app_color_style.dart';
import '../../core/theme/app_text_style.dart';
import 'bloc/timekeeping_bloc.dart';
import 'bloc/timekeeping_state.dart';
import 'model/timekeeping_model.dart';
import 'widget/timekeeping_item.dart';

class TimekeepingScreen extends StatefulWidget {
  const TimekeepingScreen({super.key});

  @override
  State<TimekeepingScreen> createState() => _TimekeepingScreenState();
}

class _TimekeepingScreenState extends State<TimekeepingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeKeepingCubit(),
      //..getTimeKeeping(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<TimeKeepingCubit, TimeKeepingState>(
          listenWhen: (previous, current) =>
              previous.message != current.message,
          listener: (context, state) {
            if (state.message != null && state.message != '') {
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder<TimeKeepingCubit, TimeKeepingState>(
            builder: (context, state) {
              final cubit = context.read<TimeKeepingCubit>();
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    cubit.addTimeKeeping(TimeKeepingModel(
                                  checkinAt: DateTime.now(),
                                  note: "dung gio",
                                  status: 'checked-in',
                                )),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.grey_2,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    "CheckIn",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.s18_medium.copyWith(
                                        color: const Color(0xFF08142D)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    cubit.addTimeKeeping(TimeKeepingModel(
                                  checkinAt: DateTime.now(),
                                  note: "dung gio",
                                  status: 'checked-out',
                                )),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.grey_2,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    "CheckOut",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.s18_medium.copyWith(
                                        color: const Color(0xFF08142D)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        BlocProvider(
                          create: (context) => TimeKeepingCubit(),
                          child: BlocProvider(
                            create: (context) =>
                                TimeMyKeepingCubit()..getTimeMyKeeping(),
                            child: BlocBuilder<TimeMyKeepingCubit,
                                TimeMyKeepingState>(
                              builder: (context, state) {
                                if (state is TimeMyKeepingLoadingState) {
                                  return Center(child: LoadingCircular());
                                } else if (state is TimeMyKeepingFailedState) {
                                  return const Center(
                                      child: Text('Đã xảy ra lỗi!'));
                                } else if (state is TimeMyKeepingSuccessState) {
                                  final data = state.timeMyKeepingList;
                                  return FutureBuilder<String?>(
                                    future: SecureStorage.getUserId(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      final userId = snapshot.data!;
                                      final filteredItems = data
                                          ?.where(
                                              (item) => item.idUser == userId)
                                          .toList();

                                      return Expanded(
                                        child: filteredItems == null ||
                                                filteredItems.isEmpty
                                            ? const Center(
                                                child:
                                                    Text('Không có dữ liệu '))
                                            : SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 16),
                                                    ...filteredItems
                                                        .map((item) {
                                                      final formattedDate = item
                                                          .checkinAt
                                                          .split('T')[0];
                                                      final formattedCheckin =
                                                          item.checkinAt
                                                              .split('T')[1];
                                                      final formattedCheckout =
                                                          item.checkoutAt !=
                                                                  null
                                                              ? item.checkoutAt!
                                                                  .split('T')[1]
                                                              : 'Chưa check-out'; // Hiển thị thông báo hoặc giá trị mặc định nếu null
                                                      return TimekeepingItem(
                                                        date: formattedDate,
                                                        checkinTime:
                                                            formattedCheckin,
                                                        checkoutTime:
                                                            formattedCheckout,
                                                      );
                                                    }).toList(),
                                                    const SizedBox(height: 16),
                                                  ],
                                                ),
                                              ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.isLoading)
                    const Positioned.fill(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
