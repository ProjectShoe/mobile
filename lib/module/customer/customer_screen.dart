import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/module/customer/bloc/customer_cubit.dart';
import 'package:shoes_store/module/customer/bloc/customer_state.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Khách hàng',
          textAlign: TextAlign.center,
          style: AppTextStyle.s20_bold.copyWith(color: const Color(0xFF08142D)),
        ),
        centerTitle: true,
      ),
      body: const Column(
        children: [SearchWidget(), CustomerList()],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          context.pushNamed('addCustomer');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(246, 246, 246, 1),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 6, left: 12),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 19.6 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                      color: Colors.black),
                ),
                cursorColor: Colors.black,
                cursorHeight: 20,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFF3C3C3C)),
              child: Center(
                child: SvgPicture.asset(
                  IconPath.search,
                  color: Colors.white,
                  width: 20,
                  height: 20,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomerList extends StatefulWidget {
  const CustomerList({
    super.key,
  });

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final List<String> options = [
    "Tất cả khách hàng",
    "Khách hàng tiềm năng",
    "Khách hàng mới",
    "Khách hàng thường"
  ];
  String? selectedOptions = 'Tất cả khách hàng';
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: const Color.fromRGBO(246, 246, 246, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  selectedOptions = value;
                });
              },
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return options.map((String name) {
                  return PopupMenuItem<String>(
                    value: name,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        name,
                        style: AppTextStyle.s16_semiBold,
                      ),
                    ),
                  );
                }).toList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      selectedOptions!,
                      style: AppTextStyle.s16_semiBold,
                    ),
                  ),
                  SvgPicture.asset(IconPath.chevronDown),
                ],
              ),
            ),
            Expanded(
              child: BlocProvider(
                  create: (context) => GetAllCustomerCubit()..getAllCustomer(),
                  child: BlocBuilder<GetAllCustomerCubit, GetAllCustomerState>(
                      builder: (context, state) {
                    if (state is GetAllCustomerLoading) {
                      return const Center(child: LoadingCircular());
                    } else if (state is GetAllCustomerFailed) {
                      return const Center(
                          child: Text('Failed to load products.'));
                    } else if (state is GetAllCustomerError) {
                      return Center(
                          child: Text('Error: ${state.errorMessage}'));
                    } else if (state is GetAllCustomerSuccess) {
                      final data = state.customers;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          String name = data[index].name;
                          String phoneNumber = data[index].phone;
                          String address = data[index].address;
                          String email = data[index].email;
                          return CustomerCard(
                            name: name,
                            phoneNumber: phoneNumber,
                            address: address,
                            customerType: 'Khách mới',
                          );
                        },
                      );
                    }
                    ;
                    return const SizedBox();
                  })),
            )
          ],
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.customerType,
    required this.address,
  });
  final String name;
  final String phoneNumber;
  final String customerType;
  final String address;

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
                    customerType,
                    style:
                        AppTextStyle.s12_medium.copyWith(color: Colors.white),
                  ),
                ),
              ),
              PopupMenuButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo góc khung
                  ),
                  onSelected: (String value) {
                    // Xử lý khi người dùng chọn "Xóa" hoặc "Sửa"
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
                                    'Xóa khách hàng?',
                                    style: AppTextStyle.s16_semiBold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Bạn có chắc là muốn xóa khách hàng $name không?',
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
                            const Text('Xóa khách hàng'),
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
          Text(
            name,
            style: AppTextStyle.s16_semiBold,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SvgPicture.asset(IconPath.phone),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Số điện thoại',
                  style: AppTextStyle.s14_regular,
                ),
              ),
              const Spacer(),
              Text(
                phoneNumber,
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
              SvgPicture.asset(IconPath.mapPin),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Địa chỉ',
                  style: AppTextStyle.s14_regular,
                ),
              ),
              const SizedBox(
                width: 120,
              ),
              Expanded(
                child: Text(
                  address,
                  textAlign: TextAlign.right,
                  style: AppTextStyle.s14_medium,
                  maxLines: 2,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
