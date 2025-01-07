import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shoes_store/model/product_model.dart';
import 'package:shoes_store/model/user_model.dart';
import 'package:shoes_store/module/account/bloc/user_cubit.dart';
import 'package:shoes_store/module/account/staff_manager_screen.dart';
import 'package:shoes_store/module/account/user_info_screen.dart';
import 'package:shoes_store/module/auth/bloc/login_cubit.dart';
import 'package:shoes_store/module/customer/add_customer.dart';
import 'package:shoes_store/module/customer/bloc/customer_cubit.dart';
import 'package:shoes_store/module/customer/customer_screen.dart';
import 'package:shoes_store/module/order/add_order.dart';
import 'package:shoes_store/module/order/bloc/order_cubit.dart';
import 'package:shoes_store/module/order/selected_product.dart';
import 'package:shoes_store/module/product/bloc/product_cubit.dart';
import 'package:shoes_store/module/product/product_details_screen.dart';
import 'package:shoes_store/module/screen_manager.dart';
import 'package:shoes_store/module/account/account_screen.dart';
import 'package:shoes_store/module/auth/login_screen.dart';

import '../module/take_leave/take_leave.dart';
import '../module/take_leave_list/take_leave_list.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit(),
        child: LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/screenManager',
      name: 'screenManager',
      builder: (context, state) => BlocProvider(
          create: (context) => AddProductCubit(), child: ScreenManager()),
    ),
    GoRoute(
      path: '/selectProduct',
      name: 'selectProduct',
      builder: (context, state) => SelectedProduct(),
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) => BlocProvider(
          create: (context) => GetUserByIdCubit(), child: AccountScreen()),
    ),
    GoRoute(
      path: '/addOrder',
      name: 'addOrder',
      builder: (context, state) => BlocProvider(
        create: (context) => AddOrderCubit(),
        child: AddOrder(
          list: state.extra as List<ProductModel>,
        ),
      ),
    ),
    GoRoute(
      path: '/productDetail',
      name: 'productDetail',
      builder: (context, state) => BlocProvider(
          create: (context) => GetProductByIdCubit(),
          child: ProductDetailsScreen(
            id: '',
          )),
    ),
    GoRoute(
      path: '/staffManager',
      name: 'staffManager',
      builder: (context, state) => StaffManagerScreen(),
    ),
    GoRoute(
      path: '/userInfo',
      name: 'userInfo',
      builder: (context, state) => UserInfoScreen(
        userModel: state.extra as UserModel,
      ),
    ),
    GoRoute(
      path: '/customerManager',
      name: 'customerManager',
      builder: (context, state) => CustomerScreen(),
    ),
    GoRoute(
      path: '/addCustomer',
      name: 'addCustomer',
      builder: (context, state) => BlocProvider(
        create: (context) => AddCustomerCubit(),
        child: AddCustomerScreen(),
      ),
    ),
    GoRoute(
      path: '/takeLeave',
      name: 'takeLeave',
      builder: (context, state) => TakeLeaveScreen(),
    ),
    GoRoute(
      path: '/takeLeaveList',
      name: 'takeLeaveList',
      builder: (context, state) => TakeLeaveListScreen(),
    ),
  ],
);
