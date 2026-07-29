import 'package:flutter/material.dart';

import '../callbacks/ser_builder_callbacks.dart';
import '../contracts/ser_widget_data.dart';
import '../contracts/ser_widget_type.dart';
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

/// Entry point of the SerBuilder widget system: turns a backend JSON
/// response into a rendered, vertically-stacked screen (§1.1 of the widget
/// catalog doc).
class SerWidgets {
  const SerWidgets._();

  /// Parses `{ "data": [ ... ] }` (or a bare list) into widget entries.
  static List<SerWidgetData> fromJson(dynamic json) => SerWidgetData.listFromJson(json);

  /// Maps parsed widget entries to their Flutter widgets, in order.
  static List<Widget> getScreen({
    required List<SerWidgetData> data,
    required SerBuilderCallbacks callbacks,
  }) {
    return data.map((entry) => _build(entry, callbacks)).toList();
  }

  static Widget _build(SerWidgetData entry, SerBuilderCallbacks callbacks) {
    final params = entry.params;
    switch (entry.type) {
      case SerWidgetType.text:
        return SerTextWidget(params: params);
      case SerWidgetType.divider:
        return SerDividerWidget(params: params);
      case SerWidgetType.image:
        return SerImageWidget(params: params, callbacks: callbacks);
      case SerWidgetType.imageList:
        return SerImageListWidget(params: params, callbacks: callbacks);
      case SerWidgetType.slider:
        return SerSliderWidget(params: params, callbacks: callbacks);
      case SerWidgetType.imageCarousel:
        return SerImageCarouselWidget(params: params, callbacks: callbacks);
      case SerWidgetType.carousel:
        return SerCarouselWidget(params: params, callbacks: callbacks);
      case SerWidgetType.grid:
        return SerGridWidget(params: params, callbacks: callbacks);
      case SerWidgetType.productCard:
      case SerWidgetType.productImage:
        return SerProductCardWidget(params: params, callbacks: callbacks);
      case SerWidgetType.flashSale:
        return SerFlashSaleWidget(params: params, callbacks: callbacks);
      case SerWidgetType.mixedCarousel:
        return SerMixedCarouselWidget(params: params, callbacks: callbacks);
      case SerWidgetType.modal:
        return SerModalWidget(params: params, callbacks: callbacks);
      case SerWidgetType.videoList:
        return SerVideoListWidget(params: params, callbacks: callbacks);
      case SerWidgetType.story:
        return SerStoryWidget(params: params, callbacks: callbacks);
      case SerWidgetType.visitedProducts:
        return SerVisitedProductsWidget(params: params, callbacks: callbacks);
      case SerWidgetType.timeImage:
        return SerTimeImageWidget(params: params);
      case SerWidgetType.youtube:
        return SerYoutubeWidget(params: params);
      case SerWidgetType.search:
        return SerSearchWidget(params: params, callbacks: callbacks);
      case SerWidgetType.fastRegister:
        return SerFastRegisterWidget(params: params);
      case SerWidgetType.unknown:
        return const SerUnknownWidget();
    }
  }
}
