import 'package:flutter/material.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/home/filter_screen.dart';
import '../screens/home/products_screen.dart';
import '../screens/orders/order_success_screen.dart';
import '../screens/review/write_review_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/product_detail_screen.dart';
import '../screens/home/category_screen.dart';
import '../screens/home/search_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/cart/checkout_screen.dart';
import '../screens/orders/my_orders_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/wishlist/favorites_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPass = '/forgot-password';
  static const String home = '/home';
  static const String filter = '/filter';
  static const String productDetail = '/product-detail';
  static const String products = '/products';
  static const String category = '/category';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String myOrders = '/my-orders';
  static const String orderDetail = '/order-detail';
  static const String orderSuccess = '/order-success';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String favorites = '/favorites';
  static const String writeReview = '/write-review';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _route(const SplashScreen());
      case welcome:
        return _route(const WelcomeScreen());
      case login:
        return _route(const LoginScreen());
      case otp:
        return _route(const OtpScreen());
      case register:
        return _route(const RegisterScreen());
      case forgotPass:
        return _route(const ForgotPasswordScreen());
      case home:
        return _route(const HomeScreen());
      case filter:
        return _route(const FilterScreen());
      case productDetail:
        return _route(const ProductDetailScreen());
      case products:
        return _route(const ProductsScreen());
      case category:
        return _route(const CategoryScreen());
      case search:
        return _route(const SearchScreen());
      case cart:
        return _route(const CartScreen());
      case checkout:
        return _route(const CheckoutScreen());
      case myOrders:
        return _route(const MyOrdersScreen());
      case orderDetail:
        return _route(const OrderDetailScreen());
      case orderSuccess:
        return _route(const OrderSuccessScreen());
      case profile:
        return _route(const ProfileScreen());
      case editProfile:
        return _route(const EditProfileScreen());
      case favorites:
        return _route(const FavoritesScreen());
      case writeReview:
        return _route(const WriteReviewScreen());
      default:
        return _route(const LoginScreen());
    }
  }

  static MaterialPageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}
