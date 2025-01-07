import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/module/widget/add_button.dart';
import 'package:shoes_store/module/widget/divider_line.dart';
import 'package:shoes_store/module/widget/user_info_card.dart';

class StaffManagerScreen extends StatelessWidget {
  const StaffManagerScreen({super.key});

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
          title: Text(
            'Quản lý nhân viên',
            textAlign: TextAlign.center,
            style:
                AppTextStyle.s20_bold.copyWith(color: const Color(0xFF08142D)),
          ),
        ),
        body: const Stack(children: [
          Column(
            children: [
              TabBar(
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColorStyle.blue,
                  indicatorColor: AppColorStyle.blue,
                  labelStyle: AppTextStyle.s14_semiBold,
                  tabs: [
                    Tab(
                      text: 'Thành viên',
                    ),
                    Tab(
                      text: 'Xin nghỉ phép',
                    ),
                  ]),
              DividerLine(),
              Expanded(child: TabBarView(children: [StaffList(), Text('data')]))
            ],
          ),
          AddButton(
            title: 'Thêm nhân viên',
          ),
        ]),
      ),
    );
  }
}

class StaffList extends StatelessWidget {
  const StaffList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {'id': 'NV-001', 'name': 'Nguyễn Văn Minh'},
      {'id': 'NV-002', 'name': 'Trần Thị Hoa'},
      {'id': 'NV-003', 'name': 'Phạm Quang Huy'},
      {'id': 'NV-004', 'name': 'Lê Ngọc Anh'},
      {'id': 'NV-005', 'name': 'Vũ Thị Lan'},
    ];

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        String name = data[index]['name'];
        String id = data[index]['id'];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
              onTap: () {
                context.pushNamed('userInfo');
              },
              child: UserInfoCard(name: name, id: id, sizeImage: 52)),
        );
      },
    );
  }
}
