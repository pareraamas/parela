// ignore_for_file: constant_identifier_names
part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const MAIN = _Paths.MAIN;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const CATEGORY_PRODUCTS = _Paths.CATEGORY_PRODUCTS;
  static const ALL_PRODUCTS = _Paths.ALL_PRODUCTS;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const ORDER_SUCCESS = _Paths.ORDER_SUCCESS;
  static const MY_ORDERS = _Paths.MY_ORDERS;
  static const ORDER_DETAIL = _Paths.ORDER_DETAIL;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const SELLER_STORE = _Paths.SELLER_STORE;
  static const CART = _Paths.CART;
  static const MESSAGES = _Paths.MESSAGES;
  static const CHAT = _Paths.CHAT;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const MAIN = '/main';
  static const PRODUCT_DETAIL = '/product-detail';
  static const CATEGORY_PRODUCTS = '/category-products';
  static const ALL_PRODUCTS = '/all-products';
  static const CHECKOUT = '/checkout';
  static const ORDER_SUCCESS = '/order-success';
  static const MY_ORDERS = '/my-orders';
  static const ORDER_DETAIL = '/order-detail';
  static const NOTIFICATIONS = '/notifications';
  static const EDIT_PROFILE = '/edit-profile';
  static const SELLER_STORE = '/seller-store';
  static const CART = '/cart';
  static const MESSAGES = '/messages';
  static const CHAT = '/chat';
}
