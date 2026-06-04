import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // App open
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  // Login
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // Register
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // Product view
  Future<void> logProductView(String productId, String productName) async {
    await _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
        ),
      ],
    );
  }

  // Add to cart
  Future<void> logAddToCart(
      String productId, String productName, double price) async {
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          price: price,
        ),
      ],
    );
  }

  // Purchase
  Future<void> logPurchase(String orderId, double total) async {
    await _analytics.logPurchase(
      transactionId: orderId,
      value: total,
      currency: 'USD',
    );
  }

  // Search
  Future<void> logSearch(String query) async {
    await _analytics.logSearch(searchTerm: query);
  }

  // Category view
  Future<void> logCategoryView(String category) async {
    await _analytics.logViewItemList(
      itemListName: category,
    );
  }

  // Custom event
  Future<void> logEvent(
      String name, {
        Map<String, Object>? parameters,
      }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}