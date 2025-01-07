import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/model/user_model.dart';
import 'package:shoes_store/module/take_leave_list/bloc/take_leave_list_bloc.dart';
import 'package:shoes_store/module/take_leave_list/bloc/take_leave_list_state.dart';
import 'package:shoes_store/module/take_leave_list/widget/take_list_item.dart';
import 'package:shoes_store/module/widget/divider_line.dart';
import 'package:shoes_store/module/widget/user_info_card.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({super.key, required this.userModel});
  UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserInfoCard(
                  name: userModel.username,
                  id: userModel.isAdmin ? 'Quản lý' : 'Nhân viên',
                  sizeImage: 96),
            ),
            const SizedBox(
              height: 4,
            ),
            const TabBar(
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColorStyle.blue,
                indicatorColor: AppColorStyle.blue,
                labelStyle: AppTextStyle.s14_semiBold,
                tabs: [
                  Tab(
                    text: 'Giới thiệu',
                  ),
                  Tab(
                    text: 'Ngày nghỉ phép',
                  ),
                ]),
            const DividerLine(),
            Expanded(
              child: TabBarView(
                children: [
                  IntroduceWidget(
                    userModel: userModel,
                  ),
                  BlocProvider(
                    create: (context) => TakeLeaveListCubit()..getLeaveList(),
                    child: BlocBuilder<TakeLeaveListCubit, TakeLeaveListState>(
                      builder: (context, state) {
                        final cubit = context.read<TakeLeaveListCubit>();
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 230, 230, 230),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: state.takeList == null || state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...state.takeList!.map(
                                        (it) => TakeListItem(item: it),
                                      ),
                                      if (state.takeList!.isEmpty)
                                        Center(
                                          child: Text(
                                            "Chưa có đơn xin nghỉ phép nào",
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.s20_regular
                                                .copyWith(
                                                    color: const Color(
                                                        0xFF08142D)),
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IntroduceWidget extends StatelessWidget {
  IntroduceWidget({super.key, required this.userModel});
  UserModel userModel;
  @override
  Widget build(BuildContext context) {
    String formatDateTime(String input) {
      DateTime dateTime = DateTime.parse(input);

      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;

      String twoDigits(int n) => n.toString().padLeft(2, '0');

      String formattedDate = '${twoDigits(day)}/${twoDigits(month)}/$year';

      return formattedDate;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thông tin làm việc',
                    style: AppTextStyle.s14_semiBold,
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chi nhánh',
                    style: AppTextStyle.s14_regular,
                  ),
                  Text('Hà Nội', style: AppTextStyle.s14_medium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ngày vào làm', style: AppTextStyle.s14_regular),
                  Text(
                    formatDateTime(userModel.createdAt),
                    style: AppTextStyle.s14_medium,
                  )
                ],
              )
            ],
          ),
        ),
        const DividerLine(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thông tin liên hệ',
                    style: AppTextStyle.s14_semiBold,
                  ),
                  Text(
                    'Chỉnh sửa',
                    style: AppTextStyle.s14_medium
                        .copyWith(color: AppColorStyle.blue),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số điện thoại',
                    style: AppTextStyle.s14_regular,
                  ),
                  Text(userModel.phone, style: AppTextStyle.s14_medium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Email', style: AppTextStyle.s14_regular),
                  Text(
                    userModel.email,
                    style: AppTextStyle.s14_medium,
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 100),
                    child:
                        Text('Chỗ ở hiện tại', style: AppTextStyle.s14_regular),
                  ),
                  Flexible(
                    child: Text(
                      userModel.address,
                      style: AppTextStyle.s14_medium,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 100),
                    child:
                        Text('Số tài khoản', style: AppTextStyle.s14_regular),
                  ),
                  Flexible(
                    child: Text(
                      userModel.bankCode,
                      style: AppTextStyle.s14_medium,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const DividerLine(),
      ],
    );
  }
}
