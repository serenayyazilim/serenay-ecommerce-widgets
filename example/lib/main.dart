import 'package:flutter/material.dart';
import 'package:mobile_ecommerce_widgets/mobile_ecommerce_widgets.dart';

void main() {
  runApp(const DemoApp());
}

/// A small showcase app that renders a mock backend JSON payload through
/// [WidgetCatalog] to manually exercise every catalog widget during
/// development.
class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Catalog Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)),
      home: const ScreenPage(),
    );
  }
}

/// Demonstrates a full backend-driven screen backed by an in-memory mock
/// repository standing in for a real backend.
class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  final bool _isLoggedIn = true;
  final List<ProductCardData> _products = _mockProducts();
  final List<ProductCardData> _visited = _mockProducts().take(3).toList();

  late final _callbacks = WidgetCallbacks(
    onAction: (action) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action: ${action.type.name} id=${action.id ?? action.goto ?? '-'}')),
    ),
    fetchProducts: (query) async {
      await Future.delayed(const Duration(milliseconds: 300));
      return _products;
    },
    fetchSlides: (id) async {
      await Future.delayed(const Duration(milliseconds: 200));
      return List.generate(
        3,
        (i) => SlideItem(
          image: 'https://picsum.photos/seed/slide$id$i/800/400',
          action: const WidgetAction(type: WidgetActionType.category, id: 1),
        ),
      );
    },
    fetchVideos: (id) async => const [
      VideoItem(
        video: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        action: WidgetAction(type: WidgetActionType.category, id: 1),
      ),
    ],
    fetchModal: (id) async => 'https://picsum.photos/seed/modal$id/600/800',
    isLoggedIn: () => _isLoggedIn,
    onRequireAuth: () => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You need to log in')),
    ),
    onToggleFavorite: (product) async {
      final updated = !product.isFavorited;
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) _products[index] = product.copyWith(isFavorited: updated);
      });
      return updated;
    },
    onAddToCart: (product, variant, quantity) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart: ${product.title} x$quantity')),
      );
    },
    visitedProducts: () => _visited,
  );

  @override
  Widget build(BuildContext context) {
    final screenData = WidgetCatalog.fromJson(_mockScreenJson);
    final widgets = WidgetCatalog.getScreen(data: screenData, callbacks: _callbacks);

    return Scaffold(
      body: ListView(children: widgets),
    );
  }
}

List<ProductCardData> _mockProducts() => List.generate(
      6,
      (i) => ProductCardData(
        id: i + 1,
        image: 'https://picsum.photos/seed/product$i/400/400',
        title: 'Product ${i + 1}',
        subtitle: 'Brand ${i % 3}',
        price: 99.9 + i * 10,
        priceOld: i.isEven ? 149.9 + i * 10 : null,
        discount: i.isEven ? '${20 + i}' : null,
        isFavorited: i == 1,
        variants: i == 0
            ? const [
                ProductVariant(id: 'v1', name: 'Red'),
                ProductVariant(id: 'v2', name: 'Blue'),
              ]
            : const [],
        measureOptions: i == 0 ? const ['S', 'M', 'L'] : const [],
        saleDisabled: i == 5,
        saleDisabledReason: i == 5 ? 'Out of stock' : null,
      ),
    );

final _mockScreenJson = {
  'data': [
    {
      'type': 'TEXT',
      'params': {'text': 'Widget Catalog Demo', 'style': 'section', 'subtitle': 'Full widget catalog'},
    },
    {
      'type': 'SEARCH',
      'params': {'hint_text': 'Search products, brands...'},
    },
    {
      'type': 'SLIDER',
      'params': {'id': 1, 'height_percent': 0.35},
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'STORY',
      'params': {
        'list': [
          {
            'thumbnail': 'https://picsum.photos/seed/story1/100/100',
            'urls': ['https://picsum.photos/seed/story1a/800/1400'],
            'contain': 'View Product',
            'type': 'product',
            'product_id_or_url': 1,
          },
          {
            'thumbnail': 'https://picsum.photos/seed/story2/100/100',
            'urls': ['https://picsum.photos/seed/story2a/800/1400'],
          },
        ],
      },
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'TEXT',
      'params': {'text': 'Featured', 'style': 'section'},
    },
    {
      'type': 'CAROUSEL',
      'params': {'category_id': 1, 'limit': 10},
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'FLASHSALE',
      'params': {
        'title': 'Flash Sale',
        'subtitle': 'Grab it before time runs out',
        'end_time': null,
      },
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'IMAGE',
      'params': {
        'url': 'https://picsum.photos/seed/banner/800/300',
        'type': 'category',
        'id': 2,
        'height_percent': 0.3,
        'radius': 12,
        'padding': 16,
      },
    },
    {
      'type': 'IMAGELIST',
      'params': {
        'list': [
          {'url': 'https://picsum.photos/seed/il1/400/200', 'type': 'category', 'id': 1},
          {'url': 'https://picsum.photos/seed/il2/400/200', 'type': 'category', 'id': 2},
        ],
      },
    },
    {
      'type': 'IMAGECAROUSEL',
      'params': {'id': 2, 'height_percent': 0.35, 'item_count': 2, 'bg_image': ''},
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'TEXT',
      'params': {'text': 'All Products', 'style': 'section'},
    },
    {
      'type': 'GRID',
      'params': {'category_id': 1},
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'PRODUCTCARD',
      'params': {'category_id': 1},
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'MIXEDCAROUSEL',
      'params': {
        'height_percent': 1.0,
        'items': [
          {
            'item_type': 'image',
            'bg_color': '#222222',
            'url': 'https://picsum.photos/seed/mix1/800/800',
            'type': 'category',
            'id': 1,
          },
          {
            'item_type': 'products',
            'bg_color': '#FFF7EC',
            'title': 'Just For You',
            'category_id': 1,
          },
        ],
      },
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'VISITEDPRODUCTS',
      'params': {'limit': 5},
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'TIMEIMAGE',
      'params': {
        'url': 'https://picsum.photos/seed/timeimage/800/400',
        'title': 'Campaign Ends In',
        'title_position': 'bottom',
        'title_color': '#FFFFFF',
      },
    },
    {
      'type': 'YOUTUBE',
      'params': {'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'},
    },
    {
      'type': 'VIDEOLIST',
      'params': {'id': 1},
    },
    {
      'type': 'FASTREGISTER',
      'params': {},
    },
    {
      'type': 'MODAL',
      'params': {'url': 'https://picsum.photos/seed/modalwelcome/600/800', 'type': 'category', 'id': 1},
    },
    {'type': 'UNKNOWN_FUTURE_TYPE', 'params': {}},
  ],
};
