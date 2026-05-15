class AppConstants {
  AppConstants._();

  // Cloudinary
  static const String cloudinaryCloudName = 'dehjub5m1';
  static const String cloudinaryBaseUrl =
      'https://res.cloudinary.com/$cloudinaryCloudName/image/upload';

  // Image transformations (auto format + quality = bandwidth সাশ্রয়)
  static const String imgTransform = 'f_auto,q_auto';

  static String imageUrl(String publicId) =>
      '$cloudinaryBaseUrl/$imgTransform/$publicId';

  // Firestore collections
  static const String usersCol    = 'users';
  static const String productsCol = 'products';
  static const String ordersCol   = 'orders';
  static const String cartsCol    = 'carts';

}
