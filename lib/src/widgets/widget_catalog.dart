import 'package:flutter/material.dart';

import '../callbacks/widget_callbacks.dart';
import '../contracts/widget_entry.dart';
import '../contracts/widget_type.dart';
import '../core/theme/ecommerce_widget_theme.dart';
import 'catalog/carousel_widget.dart';
import 'catalog/divider_widget.dart';
import 'catalog/fast_register_widget.dart';
import 'catalog/flash_sale_widget.dart';
import 'catalog/grid_widget.dart';
import 'catalog/image_carousel_widget.dart';
import 'catalog/image_list_widget.dart';
import 'catalog/image_widget.dart';
import 'catalog/mixed_carousel_widget.dart';
import 'catalog/modal_widget.dart';
import 'catalog/product_card_widget.dart';
import 'catalog/search_widget.dart';
import 'catalog/slider_widget.dart';
import 'catalog/story_widget.dart';
import 'catalog/text_widget.dart';
import 'catalog/time_image_widget.dart';
import 'catalog/unknown_widget.dart';
import 'catalog/video_list_widget.dart';
import 'catalog/visited_products_widget.dart';
import 'catalog/youtube_widget.dart';

/// Entry point of the widget system: turns a backend JSON response into a
/// rendered, vertically-stacked screen (§1.1 of the widget catalog doc).
class WidgetCatalog {
  const WidgetCatalog._();

  /// Parses `{ "data": [ ... ] }` (or a bare list) into widget entries.
  static List<WidgetEntry> fromJson(dynamic json) => WidgetEntry.listFromJson(json);

  /// Maps parsed widget entries to their Flutter widgets, in order.
  ///
  /// [theme] lets the host app re-brand colors, text styles and sizes across
  /// every rendered widget; omit it to use the package defaults.
  static List<Widget> getScreen({
    required List<WidgetEntry> data,
    required WidgetCallbacks callbacks,
    EcommerceWidgetTheme theme = const EcommerceWidgetTheme(),
  }) {
    return data.map((entry) => _build(entry, callbacks, theme)).toList();
  }

  static Widget _build(
    WidgetEntry entry,
    WidgetCallbacks callbacks,
    EcommerceWidgetTheme theme,
  ) {
    final params = entry.params;
    switch (entry.type) {
      case WidgetType.text:
        return TextWidget(params: params, theme: theme);
      case WidgetType.divider:
        return DividerWidget(params: params);
      case WidgetType.image:
        return ImageWidget(params: params, callbacks: callbacks);
      case WidgetType.imageList:
        return ImageListWidget(params: params, callbacks: callbacks);
      case WidgetType.slider:
        return SliderWidget(params: params, callbacks: callbacks);
      case WidgetType.imageCarousel:
        return ImageCarouselWidget(params: params, callbacks: callbacks);
      case WidgetType.carousel:
        return CarouselWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.grid:
        return GridWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.productCard:
      case WidgetType.productImage:
        return ProductCardWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.flashSale:
        return FlashSaleWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.mixedCarousel:
        return MixedCarouselWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.modal:
        return ModalWidget(params: params, callbacks: callbacks);
      case WidgetType.videoList:
        return VideoListWidget(params: params, callbacks: callbacks);
      case WidgetType.story:
        return StoryWidget(params: params, callbacks: callbacks);
      case WidgetType.visitedProducts:
        return VisitedProductsWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.timeImage:
        return TimeImageWidget(params: params);
      case WidgetType.youtube:
        return YoutubeWidget(params: params);
      case WidgetType.search:
        return SearchWidget(params: params, callbacks: callbacks, theme: theme);
      case WidgetType.fastRegister:
        return FastRegisterWidget(params: params, theme: theme);
      case WidgetType.unknown:
        return const UnknownWidget();
    }
  }
}
