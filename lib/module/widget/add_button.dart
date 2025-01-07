import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
              colors: [AppColorStyle.blue, Color(0xFF1ADDD2)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: Center(
        child: Row(children: [
          SvgPicture.asset(
            IconPath.plus,
            width: 18,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: AppTextStyle.s15_bold.copyWith(color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
