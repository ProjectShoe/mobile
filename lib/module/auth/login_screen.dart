import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/module/auth/bloc/login_cubit.dart';
import 'package:shoes_store/module/auth/bloc/login_state.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      body: Stack(alignment: Alignment.center, children: [
        Positioned.fill(
          child: Image.asset(
            ProductPath.background,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 317,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              // ignore: prefer_const_constructors
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Đăng nhập",
                      style: AppTextStyle.s20_bold,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      label: 'Email',
                      data: _email,
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      label: 'Mật khẩu',
                      data: _password,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const MoreSelection(),
                    const SizedBox(
                      height: 25,
                    ),
                    BlocListener<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginLoading) {
                          showDialog(
                            context: context,
                            builder: (context) => const Center(
                              child: LoadingCircular(),
                            ),
                          );
                        } else if (state is LoginSuccess) {
                          context.pop();
                          context.pushNamed('screenManager');
                        } else if (state is LoginFailed) {
                          context.pop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
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
                                          'Thông báo',
                                          style: AppTextStyle.s16_semiBold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40.0,
                                        ),
                                        child: const Text(
                                          'Sai tên tài khoản hoặc mật khẩu, vui lòng đăng nhập lại!',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.s14_medium,
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () => context.pop(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                child: Text(
                                                  'Ok',
                                                  style: AppTextStyle.s15_bold
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: const SizedBox(),
                    ),
                    InkResponse(
                      onTap: () => context
                          .read<LoginCubit>()
                          .login(_email.text, _password.text),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                                colors: [AppColorStyle.blue, Color(0xFF1ADDD2)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight)),
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: AppTextStyle.s15_bold
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class MoreSelection extends StatefulWidget {
  const MoreSelection({
    super.key,
  });

  @override
  State<MoreSelection> createState() => _MoreSelectionState();
}

class _MoreSelectionState extends State<MoreSelection> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Checkbox(
            activeColor: AppColorStyle.blue,
            side: const BorderSide(color: Colors.grey),
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = !isChecked;
              });
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        const Text(
          "Lưu tài khoản",
          style: AppTextStyle.s13_medium,
        ),
        const Spacer(),
        Text(
          'Quên mật khẩu?',
          style: AppTextStyle.s13_semiBold.copyWith(color: AppColorStyle.blue),
        )
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.data,
    required this.obscureText,
  });

  final String label;
  final TextEditingController data;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: TextField(
          style: const TextStyle(),
          cursorColor: Colors.black,
          textInputAction: TextInputAction.done,
          controller: data,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            focusColor: Colors.green,
          ),
          obscureText: obscureText,
        ),
      ),
    );
  }
}
