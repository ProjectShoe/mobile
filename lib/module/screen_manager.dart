import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/module/account/account_screen.dart';
import 'package:shoes_store/module/order/order_manager.dart';
import 'package:shoes_store/module/product/category_screen.dart';
import 'package:shoes_store/module/timekeeping/timekeeping.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key, this.selectedInd = 0});

  final int selectedInd;

  @override
  State<ScreenManager> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<ScreenManager> {
  int selectedIndex = 0;

  List<PreferredSizeWidget> titleList = [
    const Header(title: 'Quản lý sản phẩm'),
    const Header(title: 'Quản lý bán hàng'),
    const Header(title: 'Chấm công'),
    const Header(title: 'Tài khoản'),
  ];
  List<Widget> bodyList = [
    const ProductManagerScreen(),
    const OrderManager(),
    const TimekeepingScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: titleList[selectedIndex],
        body: bodyList[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          selectedItemColor: AppColorStyle.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFFFFFFF),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                IconPath.shoes,
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                IconPath.shoes,
                width: 24,
                height: 24,
                color: AppColorStyle.black,
              ),
              label: 'QL Sản phẩm',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconPath.saleManagementIcon,
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  IconPath.saleManagementIcon,
                  width: 24,
                  height: 24,
                  color: AppColorStyle.black,
                ),
                label: 'QL Bán hàng'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconPath.revenueManagementIcon,
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  IconPath.revenueManagementIcon,
                  width: 24,
                  height: 24,
                  color: AppColorStyle.black,
                ),
                label: 'Chấm công'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconPath.accountIcon,
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  IconPath.accountIcon,
                  width: 24,
                  height: 24,
                  color: AppColorStyle.black,
                ),
                label: 'Tài khoản'),
          ],
        ));
  }
}
