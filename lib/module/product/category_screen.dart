import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';
import 'package:shoes_store/module/order/add_order.dart';
import 'package:shoes_store/module/product/bloc/product_cubit.dart';
import 'package:shoes_store/module/product/bloc/product_state.dart';
import 'package:shoes_store/module/widget/add_button.dart';
import 'package:shoes_store/module/widget/loading_circular.dart';
import 'package:shoes_store/module/widget/product_card.dart';

class ProductManagerScreen extends StatelessWidget {
  const ProductManagerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {'id': 0, 'name': 'Tất cả'},
      {'id': 1, 'name': 'Mới về'},
      {'id': 2, 'name': 'Khuyến mãi'},
      {'id': 3, 'name': 'Vans'},
      {'id': 4, 'name': 'Bitis'}
    ];
    return BlocProvider(
      create: (context) => AddProductCubit(),
      child: Material(
        child: DefaultTabController(
            length: data.length,
            child: ColoredBox(
              color: const Color(0xFFFFFFFF),
              child: SafeArea(
                child: Stack(children: [
                  Column(
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
                  Positioned(
                    bottom: 40,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return BlocProvider.value(
                              value: context.read<AddProductCubit>(),
                              child: const AddProduct(),
                            );
                          },
                        );
                      },
                      child: const AddButton(
                        title: 'Thêm sản phẩm',
                      ),
                    ),
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final capturedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (capturedImage != null) {
      setState(() {
        _selectedImage = File(capturedImage.path);
      });
    }
  }

  final TextEditingController name = TextEditingController();
  final TextEditingController cost = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 530,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Thêm Ảnh:  ',
                  style: AppTextStyle.s14_semiBold,
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: _selectedImage == null
                      ? const Text('')
                      : Image.file(
                          _selectedImage!,
                          fit: BoxFit.fill,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      IconPath.upload,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _captureImage();
                  },
                  child: SvgPicture.asset(
                    IconPath.camera,
                    width: 30,
                    height: 30,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Tên sản phẩm:',
              style: AppTextStyle.s14_semiBold,
            ),
            CustomTextField(
              height: 48,
              isNumberKeyBoard: false,
              textEditingController: name,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Số lượng:',
                      style: AppTextStyle.s14_semiBold,
                    ),
                    CustomTextField_2(
                      height: 48,
                      isNumberKeyBoard: true,
                      textEditingController: quantity,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mã sản phẩm:',
                      style: AppTextStyle.s14_semiBold,
                    ),
                    CustomTextField_2(
                      textEditingController: code,
                      height: 48,
                      isNumberKeyBoard: false,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Giá:',
              style: AppTextStyle.s14_semiBold,
            ),
            CustomTextField(
              height: 48,
              isNumberKeyBoard: true,
              textEditingController: cost,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Mô tả:',
              style: AppTextStyle.s14_semiBold,
            ),
            CustomTextField(
              height: 120,
              isNumberKeyBoard: false,
              textEditingController: detail,
            ),
            const Spacer(),
            BlocListener<AddProductCubit, AddProductState>(
              listener: (context, state) {
                if (state is AddProductLoading) {
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: LoadingCircular(),
                    ),
                  );
                } else if (state is AddProductSuccess) {
                  context.pop();
                  context.goNamed('screenManager');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SuccessNotify();
                    },
                  );
                } else if (state is AddProductFailed) {
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<AddProductCubit>().addProduct(
                          name: name.text,
                          description: detail.text,
                          price: cost.text,
                          code: code.text,
                          quantity: quantity.text);
                      context.pop();
                    },
                    child: Container(
                      height: 48,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColorStyle.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Xong',
                          style: AppTextStyle.s15_bold
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return BlocProvider(
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
                    double cost = data[index].price;
                    String image = data[index].image;
                    String id = data[index].id;
                    return ProductCard(
                      discount: quantity,
                      name: name,
                      cost: cost,
                      width: width,
                      height: height,
                      image: image,
                      id: id,
                    );
                  }));
        }
        return SizedBox();
      }),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.height,
    required this.isNumberKeyBoard,
    required this.textEditingController,
  });
  double height;
  bool isNumberKeyBoard;
  TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: TextField(
          style: const TextStyle(),
          keyboardType:
              isNumberKeyBoard ? TextInputType.number : TextInputType.text,
          cursorColor: Colors.black,
          textInputAction: TextInputAction.done,
          maxLines: 5,
          controller: textEditingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusColor: Colors.green,
          ),
          obscureText: false,
        ),
      ),
    );
  }
}

class CustomTextField_2 extends StatelessWidget {
  CustomTextField_2(
      {super.key,
      required this.height,
      required this.isNumberKeyBoard,
      required this.textEditingController});
  double height;
  bool isNumberKeyBoard;
  TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 120,
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: TextField(
          keyboardType:
              isNumberKeyBoard ? TextInputType.number : TextInputType.text,
          style: const TextStyle(),
          cursorColor: Colors.black,
          textInputAction: TextInputAction.done,
          maxLines: 5,
          controller: textEditingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusColor: Colors.green,
          ),
          obscureText: false,
        ),
      ),
    );
  }
}
