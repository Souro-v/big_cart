import 'package:big_cart/screens/profile/my_address_screen.dart';
import 'package:big_cart/screens/profile/notifications_screen.dart';
import 'package:big_cart/screens/profile/transactions_screen.dart';
import 'package:flutter/material.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/cart/shipping_address_screen.dart';
import '../screens/cart/shipping_method_screen.dart';
import '../screens/home/filter_screen.dart';
import '../screens/home/products_screen.dart';
import '../screens/orders/order_success_screen.dart';
import '../screens/orders/track_order_screen.dart';
import '../screens/profile/add_card_screen.dart';
import '../screens/profile/my_cards_screen.dart';
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
  static const String shippingMethod = '/shipping-method';
  static const String shippingAddress = '/shipping-address';
  static const String checkout = '/checkout';
  static const String trackOrder = '/track-order';
  static const String myOrders = '/my-orders';
  static const String orderDetail = '/order-detail';
  static const String orderSuccess = '/order-success';
  static const String profile = '/profile';
  static const String myAddress = '/my-address';
  static const String editProfile = '/edit-profile';
  static const String myCards = '/my-cards';
  static const String addCard = '/add-card';
  static const String notification = '/notification';
  static const String transactions = '/transaction';
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
      case shippingMethod:
        return _route(const ShippingMethodScreen());
      case shippingAddress:
        return _route(const ShippingAddressScreen());
      case myOrders:
        return _route(const MyOrdersScreen());
      case orderDetail:
        return _route(const OrderDetailScreen());
      case orderSuccess:
        return _route(const OrderSuccessScreen());
      case trackOrder:
        return _route(const TrackOrderScreen());
      case profile:
        return _route(const ProfileScreen());
      case myAddress:
        return _route(const MyAddressScreen());
      case editProfile:
        return _route(const EditProfileScreen());
      case myCards:
        return _route(const MyCardsScreen());
      case addCard:
        return _route(const AddCardScreen());
      case favorites:
        return _route(const FavoritesScreen());
      case notification:
        return _route(const NotificationsScreen());
      case transactions:
        return _route(const TransactionsScreen());
      case writeReview:
        return _route(const WriteReviewScreen());
      default:
        return _route(const LoginScreen());
    }
  }

  static MaterialPageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}
