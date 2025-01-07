import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/model/product_model.dart';
import 'package:shoes_store/module/product/bloc/product_cubit.dart';
import 'package:shoes_store/module/product/bloc/product_state.dart';
import 'package:shoes_store/module/widget/add_button.dart';
import 'package:shoes_store/module/widget/discount.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';

class SelectedProduct extends StatelessWidget {
  const SelectedProduct({super.key});
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {'id': 0, 'name': 'Tất cả'},
      {'id': 1, 'name': 'Mới về'},
      {'id': 2, 'name': 'Khuyến mãi'},
      {'id': 3, 'name': 'Vans'},
      {'id': 4, 'name': 'Bitis'}
    ];
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
          'Chọn sản phẩm',
          textAlign: TextAlign.center,
          style: AppTextStyle.s20_bold.copyWith(color: const Color(0xFF08142D)),
        ),
      ),
      body: DefaultTabController(
          length: data.length,
          child: ColoredBox(
            color: const Color(0xFFFFFFFF),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderProductManager(),
                  ItemCategoryTabbar(data: data),
                  Expanded(
                    child: TabBarView(
                      children: data.map((tab) {
                        return const ColoredBox(
                          color: Color.fromRGBO(252, 252, 252, 1),
                          child: ProductListVertical(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class ItemCategoryTabbar extends StatelessWidget
    implements PreferredSizeWidget {
  const ItemCategoryTabbar({
    super.key,
    required this.data,
  });

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(252, 252, 252, 1),
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(243, 243, 243, 1), width: 8),
          )),
      child: TabBar(
        dividerColor: Colors.transparent,
        labelColor: AppColorStyle.blue,
        unselectedLabelColor: const Color.fromRGBO(12, 12, 12, 1),
        // indicatorColor: const Color.fromRGBO(1, 82, 46, 1),
        indicatorColor: AppColorStyle.blue,
        indicatorWeight: 2,
        labelPadding: const EdgeInsets.only(top: 8, left: 16),
        tabAlignment: TabAlignment.start,
        automaticIndicatorColorAdjustment: false,
        tabs: data
            .map((tab) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    tab['name'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ))
            .toList(),
        isScrollable: true,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(44);
}

class HeaderProductManager extends StatelessWidget {
  const HeaderProductManager({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 16, bottom: 12, right: 16),
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

class ProductListVertical extends StatefulWidget {
  const ProductListVertical({
    super.key,
  });

  @override
  State<ProductListVertical> createState() => _ProductListVerticalState();
}

class _ProductListVerticalState extends State<ProductListVertical> {
  List<ProductModel> productsList = [];

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      ProductPath.nikeairmax270,
      ProductPath.pumaRsX3,
      ProductPath.converseChuckTaylorAllStar,
      ProductPath.vansOldSkool,
      ProductPath.nikeairmax270,
    ];

    const double defaultWidth = 166;
    const double defaultHeight = 226;
    final double screenWidthRatio = MediaQuery.of(context).size.width / 375;

    const double totalTextHeight = 38;
    final double totalTextScaledHeight =
        MediaQuery.textScalerOf(context).scale(totalTextHeight);
    final double totalTextScaleIncrementDelta =
        totalTextScaledHeight - totalTextHeight;

    final double width = defaultWidth * screenWidthRatio;
    final double height =
        (defaultHeight + totalTextScaleIncrementDelta) * screenWidthRatio;

    return Stack(children: [
      BlocProvider(
        create: (context) => GetAllProductCubit()..getAllProduct(),
        child: BlocBuilder<GetAllProductCubit, GetAllProductState>(
          builder: (context, state) {
            if (state is GetAllProductLoading) {
              return const Center(child: LoadingCircular());
            } else if (state is GetAllProductFailed) {
              return const Center(child: Text('Failed to load products.'));
            } else if (state is GetAllProductError) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is GetAllProductSuccess) {
              final data = state.products;
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    crossAxisCount: 2,
                    childAspectRatio: 165.5 / 226,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    String quantity = data[index].quantity.toString();
                    String name = data[index].name;
                    String cost = data[index].price.toString();
                    String image = images[index];
                    String id = data[index].id;

                    return ProductCard(
                      discount: quantity,
                      name: name,
                      cost: cost,
                      width: width,
                      height: height,
                      image: image,
                      id: id,
                      onSelectionChanged: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            productsList.add(data[index]);
                          } else {
                            productsList.remove(data[index]);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
      Positioned(
        bottom: 40,
        right: 20,
        child: GestureDetector(
            onTap: () {
              if (productsList.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Vui lòng chọn ít nhất một sản phẩm.')),
                );
              } else {
                context.pushNamed('addOrder', extra: productsList);
              }
            },
            child: NextButton(
              title: 'Tiếp tục',
            )),
      )
    ]);
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 20,
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 27, 30, 31),
              Color.fromARGB(255, 63, 66, 66)
            ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
        child: Center(
          child: Row(children: [
            Text(
              title,
              style: AppTextStyle.s15_bold.copyWith(color: Colors.white),
            ),
            SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              IconPath.nextSvgrepoCom,
              width: 18,
              color: Colors.white,
            ),
          ]),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.discount,
    required this.name,
    required this.cost,
    required this.width,
    required this.height,
    required this.image,
    required this.id,
    required this.onSelectionChanged,
  });

  final String? discount;
  final String name;
  final String cost;
  final double width;
  final double height;
  final String image;
  final String id;
  final ValueChanged<bool> onSelectionChanged;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(8);
    final double imageSize = widget.width - padding.horizontal;

    return InkResponse(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onSelectionChanged(isSelected);
      },
      child: Container(
        padding: padding,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 167, 161, 161) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              color: Color.fromRGBO(0, 0, 0, 0.03),
            )
          ],
        ),
        child: Stack(
          children: [
            Column(
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
                      child: Image.asset(widget.image),
                    ),
                    if (widget.discount!.isNotEmpty)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Discount(discount: widget.discount),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.cost} ',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const TextSpan(
                            text: 'đ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                              decorationThickness: 1,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isSelected)
              Center(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Text(
                    'Đã chọn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
