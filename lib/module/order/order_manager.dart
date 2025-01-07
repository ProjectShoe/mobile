import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/module/order/bloc/order_cubit.dart';
import 'package:shoes_store/module/order/bloc/order_state.dart';
import 'package:shoes_store/module/widget/add_button.dart';
import 'package:shoes_store/module/widget/divider_line.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';

class OrderManager extends StatelessWidget {
  const OrderManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: BlocProvider(
        create: (_) => GetAllOrderCubit()..getAllOrder(),
        child: DefaultTabController(
          length: 3,
          child: Stack(children: [
            const Column(
              children: [
                TabBar(
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: AppColorStyle.blue,
                    indicatorColor: AppColorStyle.blue,
                    labelStyle: AppTextStyle.s14_semiBold,
                    tabs: [
                      Tab(
                        text: 'Tất cả',
                      ),
                      Tab(
                        text: 'Đang xử lý',
                      ),
                      Tab(
                        text: 'Đã hoàn thành',
                      )
                    ]),
                DividerLine(),
                Expanded(
                    child: TabBarView(
                        children: [OrderList(), OrderList(), OrderList()])),
              ],
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: GestureDetector(
                  onTap: () {
                    context.pushNamed('selectProduct').then(
                      (value) {
                        if (value == true)
                          context.read<GetAllOrderCubit>().getAllOrder();
                      },
                    );
                  },
                  child: const AddButton(title: 'Tạo đơn hàng')),
            )
          ]),
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  const OrderList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(String input) {
      DateTime dateTime = DateTime.parse(input);

      int day = dateTime.day;
      int month = dateTime.month;

      String twoDigits(int n) => n.toString().padLeft(2, '0');

      return '${twoDigits(day)}/${twoDigits(month)}';
    }

    String formatTime(String input) {
      DateTime dateTime = DateTime.parse(input);

      int hour = dateTime.hour;
      int minute = dateTime.minute;

      String twoDigits(int n) => n.toString().padLeft(2, '0');

      return '${twoDigits(hour)}:${twoDigits(minute)}';
    }

    return BlocBuilder<GetAllOrderCubit, GetAllOrderState>(
        builder: (context, state) {
      if (state is GetAllOrderLoading) {
        return const Center(child: LoadingCircular());
      } else if (state is GetAllOrderFailed) {
        return const Center(child: Text('Failed to load products.'));
      } else if (state is GetAllOrderError) {
        return Center(child: Text('Error: ${state.errorMessage}'));
      } else if (state is GetAllOrderSuccess) {
        final data = state.orders.reversed.toList();

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            int total = data[index].totalPrice;
            String time = data[index].time;
            print(total);
            return OrderCard(
                name: 'Khách lẻ',
                total: total,
                orderType: formatDate(time),
                time: formatTime(time));
          },
        );
      }
      return SizedBox();
    });
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({
    super.key,
    required this.name,
    required this.total,
    required this.orderType,
    required this.time,
  });
  final String name;
  final int total;
  final String orderType;
  final String time;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String formatCurrency(int amount) {
    String result = amount.toString();
    final regExp = RegExp(r"(\d)(?=(\d{3})+(?!\d))");
    result = result.replaceAllMapped(regExp, (match) => "${match[1]}.");

    return "$result đ";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 8, color: Color(0xFFF6F6F6)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF777777),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(
                    widget.orderType,
                    style:
                        AppTextStyle.s12_medium.copyWith(color: Colors.white),
                  ),
                ),
              ),
              PopupMenuButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (String value) {
                    if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Xóa đơn hàng?',
                                    style: AppTextStyle.s16_semiBold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Bạn có chắc là muốn xóa đơn hàng này  không?',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.s14_medium,
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 48,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColorStyle.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Hủy',
                                              style: AppTextStyle.s15_bold
                                                  .copyWith(
                                                      color:
                                                          AppColorStyle.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 48,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColorStyle.black,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Xóa',
                                              style: AppTextStyle.s15_bold
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (value == 'edit') {
                      showDialog(
                        context: context,
                        builder: (context) => Container(),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            SvgPicture.asset(IconPath.edit2),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text('Chỉnh sửa'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            SvgPicture.asset(IconPath.trash2),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text('Xóa đơn hàng'),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: SvgPicture.asset(IconPath.moreVertical)),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  widget.name,
                  style: AppTextStyle.s16_semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SvgPicture.asset(IconPath.calendar),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Thời gian',
                  style: AppTextStyle.s14_regular,
                ),
              ),
              const Spacer(),
              Text(
                widget.time,
                style: AppTextStyle.s14_medium,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(IconPath.money),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Tổng cộng',
                  style: AppTextStyle.s14_regular,
                ),
              ),
              const Spacer(),
              Text(
                formatCurrency(widget.total),
                textAlign: TextAlign.right,
                style: AppTextStyle.s14_medium,
                maxLines: 2,
              )
            ],
          )
        ],
      ),
    );
  }
}
