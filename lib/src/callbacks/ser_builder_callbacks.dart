import 'package:flutter/widgets.dart';

import '../contracts/product_card_data.dart';
import '../contracts/product_query.dart';
import '../contracts/ser_action.dart';
import '../contracts/ser_slide_item.dart';
import '../contracts/ser_video_item.dart';

/// Everything a host app must inject so the SerBuilder widget catalog can
/// stay backend-agnostic: navigation, data fetching and auth/cart state all
/// come from here instead of any global singleton (§4 of the widget catalog
/// doc).
class SerBuilderCallbacks {
  const SerBuilderCallbacks({
    required this.onAction,
    required this.fetchProducts,
    this.fetchSlides,
    this.fetchVideos,
    this.fetchModal,
    this.fetchProductDetail,
    this.isLoggedIn,
    this.onRequireAuth,
    this.onToggleFavorite,
    this.onAddToCart,
    this.visitedProducts,
    this.imageErrorBuilder,
  });

  /// Resolves any tap/navigation target produced from a widget's `type` +
  /// `id`/`url` contract.
  final void Function(SerAction action) onAction;

  /// Fetches the product list backing CAROUSEL/GRID/PRODUCTCARD/FLASHSALE/
  /// MIXEDCAROUSEL.
  final Future<List<ProductCardData>> Function(ProductQuery query)
      fetchProducts;

  /// Fetches slide items by id for SLIDER/IMAGECAROUSEL.
  final Future<List<SerSlideItem>> Function(dynamic id)? fetchSlides;

  /// Fetches videos by id for VIDEOLIST.
  final Future<List<SerVideoItem>> Function(dynamic id)? fetchVideos;

  /// Fetches popup content for a `type: "modal"` tap target.
  final Future<String?> Function(dynamic id)? fetchModal;

  /// Fetches full product detail (e.g. richer variant data) for a
  /// `type: "product"` tap target.
  final Future<ProductCardData?> Function(dynamic id)? fetchProductDetail;

  /// Whether the current user is logged in. Drives price-hiding on
  /// [ProductCardData] and hiding LOGIN/REGISTER banners.
  final bool Function()? isLoggedIn;

  /// Called when an action that needs auth (e.g. viewing a hidden price) is
  /// taken while logged out.
  final void Function()? onRequireAuth;

  /// Toggles a product's favorite state; returns the new state.
  final Future<bool> Function(ProductCardData product)? onToggleFavorite;

  /// Adds a product (optionally with a chosen variant and quantity) to the
  /// cart.
  final Future<void> Function(
    ProductCardData product,
    ProductVariant? variant,
    int quantity,
  )? onAddToCart;

  /// Returns the locally-tracked "recently visited" product list, for
  /// VISITEDPRODUCTS.
  final List<ProductCardData> Function()? visitedProducts;

  /// Optional override for the placeholder shown when a network image fails
  /// to load.
  final Widget Function()? imageErrorBuilder;
}
