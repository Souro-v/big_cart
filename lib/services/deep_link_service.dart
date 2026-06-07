import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    // if App open
    _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri, navigatorKey);
    });

    // if App closed  open
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleLink(uri, navigatorKey);
    });
  }

  void _handleLink(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
    if (uri.pathSegments.contains('product')) {
      final productId = uri.queryParameters['id'];
      if (productId != null) {
        navigatorKey.currentState?.pushNamed(
          '/product-detail',
          arguments: productId,
        );
      }
    }
  }
}