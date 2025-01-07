import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/module/product/bloc/product_cubit.dart';

import 'package:shoes_store/module/product/product_details_screen.dart';
import 'package:shoes_store/module/widget/discount.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {super.key,
      required this.discount,
      required this.name,
      required this.cost,
      required this.width,
      required this.height,
      required this.image,
      required this.id});
  final String? discount;
  final String name;
  final double cost;
  final double width;
  final double height;
  final String image;
  final String id;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String formatCurrency(double amount) {
    int amountInt = amount.toInt();

    String result = amountInt.toString();
    final regExp = RegExp(r"(\d)(?=(\d{3})+(?!\d))");
    result = result.replaceAllMapped(regExp, (match) => "${match[1]}.");

    return "$result ";
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(8);
    final double imageSize = widget.width - padding.horizontal;
    print(ApiPath.baseUrl + widget.image);
    return InkResponse(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GetProductByIdCubit(),
                child: ProductDetailsScreen(
                  id: widget.id,
                ),
              ),
            ));
      },
      child: Container(
        padding: padding,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                color: Color.fromRGBO(0, 0, 0, 0.03),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(ApiPath.baseUrl + widget.image),
                ),
                if (widget.discount!.isNotEmpty)
                  Positioned(
                      top: 4,
                      left: 4,
                      child: Discount(discount: widget.discount))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: '${formatCurrency(widget.cost)} ',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const TextSpan(
                    text: 'đ',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 1,
                        color: Colors.black),
                  )
                ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
