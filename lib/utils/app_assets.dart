import 'constants.dart';

  class AppAssets {
  AppAssets._();

  // Logo
  static const String logo = 'assets/icons/app_logo.png';

  // Icons
  static const String icGoogle = 'assets/icons/ic_google.svg';
  static const String icCart   = 'assets/icons/ic_cart.svg';
  static const String icHome   = 'assets/icons/ic_home.svg';
  static const String icOrder  = 'assets/icons/ic_order.svg';
  static const String icUser   = 'assets/icons/ic_user.svg';

  // Splash images (Cloudinary)
  static final String splash1 = AppConstants.imageUrl('splash/slide1');
  static final String splash2 = AppConstants.imageUrl('splash/slide2');
  static final String splash3 = AppConstants.imageUrl('splash/slide3');
  static final String splash4 = AppConstants.imageUrl('splash/slide4');
  // Auth images (Cloudinary)
  static final String authWelcome = AppConstants.imageUrl('auth/welcome');
  static final String authLogin   = AppConstants.imageUrl('auth/login');
  static final String authSignup  = AppConstants.imageUrl('auth/signup');
  }