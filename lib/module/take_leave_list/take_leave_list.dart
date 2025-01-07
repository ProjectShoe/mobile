import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/resources.dart';
import '../../core/theme/app_text_style.dart';
import 'bloc/take_leave_list_bloc.dart';
import 'bloc/take_leave_list_state.dart';
import 'widget/take_list_item.dart';

class TakeLeaveListScreen extends StatefulWidget {
  const TakeLeaveListScreen({super.key});

  @override
  State<TakeLeaveListScreen> createState() => _TakeLeaveListScreenState();
}

class _TakeLeaveListScreenState extends State<TakeLeaveListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TakeLeaveListCubit()..getLeaveList(),
      child: BlocBuilder<TakeLeaveListCubit, TakeLeaveListState>(
        builder: (context, state) {
          final cubit = context.read<TakeLeaveListCubit>();
          return Scaffold(
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
                "Xin nghỉ phép",
                textAlign: TextAlign.center,
                style: AppTextStyle.s20_bold
                    .copyWith(color: const Color(0xFF08142D)),
              ),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: state.takeList == null || state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    .copyWith(color: const Color(0xFF08142D)),
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                context.pushNamed('takeLeave').then((value) {
                  if (value == true) {
                    cubit.getLeaveList();
                  }
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
