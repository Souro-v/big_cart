import 'constants.dart';

class AppAssets {
  AppAssets._();

  // Logo
  static const String logo = 'assets/icons/app_logo.png';

  // Icons
  static const String icGoogle = 'assets/icons/ic_google.png';
  static const String icHome   = 'assets/icons/ic_home.png';
  static const String icOrder  = 'assets/icons/ic_order.png';
  static const String icUser   = 'assets/icons/ic_user.png';
  static const String icwish   = 'assets/icons/ic_wishlist.png';

  // Splash images (Cloudinary)
  static final String splash1 = AppConstants.imageUrl('slide1');
  static final String splash2 = AppConstants.imageUrl('slide2');
  static final String splash3 = AppConstants.imageUrl('slide3');
  static final String splash4 = AppConstants.imageUrl('slide4');

  // Auth images (Cloudinary)
  static final String authWelcome = AppConstants.imageUrl('welcome');
  static final String authLogin   = AppConstants.imageUrl('login');
  static final String authSignup  = AppConstants.imageUrl('signup');

  // Banners
  static final String banner1 = AppConstants.imageUrl('banner1');

  // Categories
  static final String catVegetables = AppConstants.imageUrl('vegetables');
  static final String catFruits     = AppConstants.imageUrl('fruits');
  static final String catBeverages  = AppConstants.imageUrl('beverages');
  static final String catGrocery    = AppConstants.imageUrl('grocery');
  static final String catEdibleOil  = AppConstants.imageUrl('edible_oil');
  static final String catHousehold  = AppConstants.imageUrl('household');

  // Products
  static final String freshPeach    = AppConstants.imageUrl('fresh_peach');
  static final String avocoda       = AppConstants.imageUrl('avocoda');
  static final String pineapple     = AppConstants.imageUrl('pineapple');
  static final String blackGrapes   = AppConstants.imageUrl('black_grapes');
  static final String pomegranate   = AppConstants.imageUrl('pomegranate');
  static final String freshBroccoli = AppConstants.imageUrl('fresh_broccoli');
}