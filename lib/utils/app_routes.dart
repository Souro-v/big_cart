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
import '../screens/profile/about_screen.dart';
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
  static const String about = '/about';
  static const String myCards = '/my-cards';
  static const String addCard = '/add-card';
  static const String notification = '/notification';
  static const String transactions = '/transaction';
  static const String favorites = '/favorites';
  static const String writeReview = '/write-review';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);
      case welcome:
        return _slideRoute(const WelcomeScreen(), settings);
      case login:
        return _slideRoute(const LoginScreen(), settings);
      case register:
        return _slideRoute(const RegisterScreen(), settings);
      case forgotPass:
        return _slideRoute(const ForgotPasswordScreen(), settings);
      case otp:
        return _slideRoute(const OtpScreen(), settings);
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      case productDetail:
        return _slideUpRoute(const ProductDetailScreen(), settings);
      case category:
        return _slideRoute(const CategoryScreen(), settings);
      case products:
        return _slideRoute(const ProductsScreen(), settings);
      case search:
        return _slideRoute(const SearchScreen(), settings);
      case filter:
        return _slideUpRoute(const FilterScreen(), settings);
      case cart:
        return _slideUpRoute(const CartScreen(), settings);
      case checkout:
        return _slideRoute(const CheckoutScreen(), settings);
      case shippingMethod:
        return _slideRoute(const ShippingMethodScreen(), settings);
      case shippingAddress:
        return _slideRoute(const ShippingAddressScreen(), settings);
      case orderSuccess:
        return _fadeRoute(const OrderSuccessScreen(), settings);
      case trackOrder:
        return _slideRoute(const TrackOrderScreen(), settings);
      case myOrders:
        return _slideRoute(const MyOrdersScreen(), settings);
      case orderDetail:
        return _slideRoute(const OrderDetailScreen(), settings);
      case profile:
        return _fadeRoute(const ProfileScreen(), settings);
      case about: return _slideRoute(const AboutScreen(), settings);

      case editProfile:
        return _slideRoute(const EditProfileScreen(), settings);
      case myAddress:
        return _slideRoute(const MyAddressScreen(), settings);
      case myCards:
        return _slideRoute(const MyCardsScreen(), settings);
      case addCard:
        return _slideRoute(const AddCardScreen(), settings);
      case notification:
        return _slideRoute(const NotificationsScreen(), settings);
      case transactions:
        return _slideRoute(const TransactionsScreen(), settings);
      case favorites:
        return _slideRoute(const FavoritesScreen(), settings);
      case writeReview:
        return _slideUpRoute(const WriteReviewScreen(), settings);
      default:
        return _slideRoute(const LoginScreen(), settings);
    }
  }

  // Normal slide
  static Route<dynamic> _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  // Slide up
  static Route<dynamic> _slideUpRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  // Fade
  static Route<dynamic> _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }
}
