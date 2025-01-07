import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/model/product_model.dart';
import 'package:shoes_store/module/order/bloc/order_cubit.dart';
import 'package:shoes_store/module/order/bloc/order_state.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';

import '../screen_manager.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({super.key, required this.list});
  final List<ProductModel> list;

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  late Map<String, int> productQuantities;
  late double totalPrice;
  late int totalQuantity;

  @override
  void initState() {
    super.initState();
    productQuantities = {
      for (var product in widget.list) product.id: 1, // Default quantity = 1
    };
    _calculateTotalPrice();
    _calculateTotalQuantity();
  }

  void _updateQuantity(String productId, int newQuantity) {
    setState(() {
      productQuantities[productId] = newQuantity;
      _calculateTotalPrice();
      _calculateTotalQuantity();
    });
  }

  void _calculateTotalPrice() {
    totalPrice = widget.list.fold(0, (sum, product) {
      return sum +
          (product.price *
              (productQuantities[product.id] ?? 1)); // Calculate total price
    });
  }

  void _calculateTotalQuantity() {
    totalQuantity = widget.list.fold(0, (sum, product) {
      return sum +
          (productQuantities[product.id] ?? 1); // Calculate total quantity
    });
  }

  String formatCurrency(double amount) {
    int amountInt = amount.toInt();

    String result = amountInt.toString();
    final regExp = RegExp(r"(\d)(?=(\d{3})+(?!\d))");
    result = result.replaceAllMapped(regExp, (match) => "${match[1]}.");

    return "$result đ";
  }

  Map<String, dynamic> createOrderData() {
    List<Map<String, dynamic>> products = widget.list.map((product) {
      return {
        "productId": product.id,
        "quantity": productQuantities[product.id].toString(),
      };
    }).toList();

    return {
      "products": products,
      "totalPrice": totalPrice.toString(),
      "status": "true",
    };
  }

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
          'Thông tin đơn hàng',
          textAlign: TextAlign.center,
          style: AppTextStyle.s20_bold.copyWith(color: const Color(0xFF08142D)),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              final product = widget.list[index];
              final quantity = productQuantities[product.id] ?? 1;

              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColorStyle.grey,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          ProductPath.converseChuckTaylorAllStar,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${formatCurrency(product.price)} VND',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  QuantitySelector(
                                    initialQuantity: quantity,
                                    onQuantityChanged: (newQuantity) {
                                      _updateQuantity(product.id, newQuantity);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng số lượng sản phẩm:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$totalQuantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng tiền hóa đơn:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${formatCurrency(totalPrice)} VND',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocListener<AddOrderCubit, AddOrderState>(
            listener: (context, state) {
              if (state is AddOrderLoading) {
                showDialog(
                  context: context,
                  builder: (context) => const Center(
                    child: LoadingCircular(),
                  ),
                );
              } else if (state is AddOrderSuccess) {
                context.goNamed('screenManager');
                // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                //   MaterialPageRoute(
                //     builder: (context) => ScreenManager(),
                //   ),
                //   ModalRoute.withName('/'),
                // );
                showDialog(
                  context: context,
                  builder: (context) {
                    return SuccessNotify();
                  },
                );
              } else if (state is AddOrderSuccess) {
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return FailedNotify();
                  },
                );
              }
            },
            child: SizedBox(),
          ),
          ElevatedButton(
            onPressed: () {
              final orderData = createOrderData();
              print(orderData);
              context.read<AddOrderCubit>().addOrder(orderData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorStyle.blue, // Màu nền
              foregroundColor: Colors.white, // Màu chữ
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16), // Khoảng cách bên trong
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc
              ),
              elevation: 4, // Hiệu ứng bóng
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 20, color: Colors.white), // Icon
                SizedBox(width: 8), // Khoảng cách giữa icon và text
                Text(
                  'Xác nhận đơn hàng',
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ
                    fontWeight: FontWeight.bold, // Chữ đậm
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SuccessNotify extends StatelessWidget {
  const SuccessNotify({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
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
                'Đã tạo đơn hàng',
                textAlign: TextAlign.center,
                style: AppTextStyle.s14_medium,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    'Ok',
                    style: AppTextStyle.s15_bold.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class FailedNotify extends StatelessWidget {
  const FailedNotify({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                'Không thể tạo đơn hàng lúc này',
                textAlign: TextAlign.center,
                style: AppTextStyle.s14_medium,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    'Ok',
                    style: AppTextStyle.s15_bold.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final void Function(int) onQuantityChanged;

  const QuantitySelector({
    Key? key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity);
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onQuantityChanged(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _decreaseQuantity,
          icon: const Icon(Icons.remove),
        ),
        Text(
          '$quantity',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: _increaseQuantity,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
