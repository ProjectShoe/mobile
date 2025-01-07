import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/module/product/bloc/product_cubit.dart';
import 'package:shoes_store/module/product/bloc/product_state.dart';
import 'package:shoes_store/module/widget/discount.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Center(
            child: SvgPicture.asset(
              IconPath.arrowLeft,
              width: 24,
              height: 24,
            ),
          ),
        ),
        title: const Text(
          'Chi tiết sản phẩm',
        ),
      ),
      body: SingleChildScrollView(
          child: ProductContent(
        id: id,
      )),
    );
  }
}

class ProductContent extends StatefulWidget {
  const ProductContent({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  final PageController controller = PageController();
  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GetProductByIdCubit()..getProductById(widget.id),
        child: BlocBuilder<GetProductByIdCubit, GetProductByIdState>(
            builder: (context, state) {
          if (state is GetProductByIdLoading) {
            return const Center(child: LoadingCircular());
          } else if (state is GetProductByIdFailed) {
            return const Center(child: Text('Failed to load product.'));
          } else if (state is GetProductByIdError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is GetProductByIdSuccess) {
            final product = state.product;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(alignment: Alignment.bottomCenter, children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width - 32,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: controller,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width - 32,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.network(
                                  ApiPath.baseUrl + product.image),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 4,
                        effect: const WormEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          activeDotColor: AppColorStyle.blue,
                          dotColor: Color(0xFFFFFFFF),
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                  color: Color(0xFF0C0C0C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Row(
                              children: [
                                Text(
                                  product.price.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Discount(discount: product.quantity.toString()),
                              ],
                            )
                          ],
                        ),
                        SvgPicture.asset(
                          IconPath.share2,
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          color: const Color(0xFF00522E),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: const Color(0xFFF3F3F3),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Mô tả sản phẩm'.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF999999)),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      product.description,
                      style: TextStyle(
                          color: Color(0xFF0C0C0C),
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        }));
  }
}

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({
    super.key,
    required this.pageName,
  });
  final String pageName;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkResponse(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              IconPath.chevronLeft,
              width: 16,
              height: 16,
              color: Colors.black,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            pageName,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SvgPicture.asset(IconPath.edit),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
