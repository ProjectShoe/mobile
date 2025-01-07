import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/constants/secure_storage.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/model/user_model.dart';
import 'package:shoes_store/module/account/bloc/user_cubit.dart';
import 'package:shoes_store/module/account/bloc/user_state.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';
import 'package:shoes_store/module/widget/user_info_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    String? id = await SecureStorage.getUserId();

    setState(() {
      userId = id; // Cập nhật trạng thái
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      // Hiển thị loading khi đang lấy `userId`
      return const Center(child: LoadingCircular());
    }
    return BlocProvider(
      create: (context) => GetUserByIdCubit()..getUserById(userId!),
      child: BlocBuilder<GetUserByIdCubit, GetUserByIdState>(
        builder: (context, state) {
          if (state is GetUserByIdLoading) {
            return const Center(child: LoadingCircular());
          } else if (state is GetUserByIdFailed) {
            return const Center(child: Text('Failed to load user data.'));
          } else if (state is GetUserByIdError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is GetUserByIdSuccess) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  UserInfoCard(
                    name: user.username,
                    id: user.isAdmin ? 'Quản lý' : 'Nhân viên',
                    sizeImage: 96,
                  ),
                  const SizedBox(height: 24),
                  UserOptionList(
                    user: user,
                  ),
                  const Spacer(),
                  const LogOutButton(),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () async {
        await SecureStorage.deleteToken();
        await SecureStorage.deleteRefreshToken();
        await SecureStorage.deleteUserId();
        context.pop();
      },
      child: Container(
        width: double.infinity,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColorStyle.grey_2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Đăng xuất',
          style: AppTextStyle.s15_bold.copyWith(color: AppColorStyle.black),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: const Color(0xFFFFFFFF),
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColorStyle.grey,
          height: 10.0,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                AppTextStyle.s20_bold.copyWith(color: const Color(0xFF08142D)),
          ),
          SvgPicture.asset(
            IconPath.notify,
            height: 24,
            width: 24,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  // ignore: invalid_use_of_visible_for_testing_member
  Size get preferredSize => Magnifier.kDefaultMagnifierSize;
}

class UserOptionList extends StatelessWidget {
  UserOptionList({super.key, required this.user});
  UserModel user;
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'title': 'Thông tin cá nhân',
        'icon': IconPath.personalInfo,
        'onTap': () {
          context.pushNamed('userInfo', extra: user);
        },
      },
      {
        'title': 'Quản lý khách hàng',
        'icon': IconPath.review,
        'onTap': () {
          context.pushNamed('customerManager');
        },
      },
      {
        'title': 'Xin nghỉ phép',
        'icon': IconPath.form,
        'onTap': () {
          context.pushNamed('takeLeaveList');
        },
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: (MediaQuery.of(context).size.width - 48) / 2 / 100),
      itemBuilder: (context, index) {
        String title = options[index]['title'];
        String icon = options[index]['icon'];
        VoidCallback onTap = options[index]['onTap'];
        return GestureDetector(
          onTap: onTap,
          child: UserOptions(
            icon: icon,
            title: title,
          ),
        );
      },
    );
  }
}

class UserOptions extends StatelessWidget {
  const UserOptions({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorStyle.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            style:
                AppTextStyle.s14_semiBold.copyWith(color: AppColorStyle.black),
          )
        ],
      ),
    );
  }
}
