import 'package:flutter/material.dart';
import 'package:serenay_ecommerce_widgets/serenay_ecommerce_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DemoApp());
}

/// A showcase app that renders a mock backend JSON payload through
/// [WidgetCatalog] inside a device-frame preview (mobile/tablet/web) with a
/// clickable widget index and live color-palette switching, to manually
/// exercise every catalog widget during development.
class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenay E-commerce Widgets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const ScreenPage(),
    );
  }
}

enum _DeviceType { mobile, tablet, web }

class _Palette {
  const _Palette(this.name, this.swatch, this.theme);
  final String name;
  final Color swatch;
  final EcommerceWidgetTheme theme;
}

final _palettes = <_Palette>[
  const _Palette('Ocean', Color(0xFF1F6FEB), EcommerceWidgetTheme()),
  const _Palette(
    'Grape',
    Color(0xFF7B2CBF),
    EcommerceWidgetTheme(
      primaryColor: Color(0xFF7B2CBF),
      secondaryColor: Color(0xFFFF9F1C),
      discountColor: Color(0xFFE63946),
      surfaceColor: Color(0xFFF5F0FF),
      textPrimaryColor: Color(0xFF2B0A45),
    ),
  ),
  const _Palette(
    'Emerald',
    Color(0xFF0E9F6E),
    EcommerceWidgetTheme(
      primaryColor: Color(0xFF0E9F6E),
      secondaryColor: Color(0xFFFACC15),
      discountColor: Color(0xFFDC2626),
      surfaceColor: Color(0xFFECFDF5),
      textPrimaryColor: Color(0xFF064E3B),
    ),
  ),
  const _Palette(
    'Sunset',
    Color(0xFFF97316),
    EcommerceWidgetTheme(
      primaryColor: Color(0xFFF97316),
      secondaryColor: Color(0xFF14B8A6),
      discountColor: Color(0xFFDB2777),
      surfaceColor: Color(0xFFFFF7ED),
      textPrimaryColor: Color(0xFF7C2D12),
    ),
  ),
  const _Palette(
    'Rose',
    Color(0xFFE11D48),
    EcommerceWidgetTheme(
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFF6366F1),
      discountColor: Color(0xFF9333EA),
      surfaceColor: Color(0xFFFFF1F2),
      textPrimaryColor: Color(0xFF4C0519),
    ),
  ),
  const _Palette(
    'Midnight',
    Color(0xFF111827),
    EcommerceWidgetTheme(
      primaryColor: Color(0xFF111827),
      secondaryColor: Color(0xFF38BDF8),
      discountColor: Color(0xFFF43F5E),
      surfaceColor: Color(0xFFF3F4F6),
      textPrimaryColor: Color(0xFF0B0F19),
    ),
  ),
];

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

  _DeviceType _device = _DeviceType.mobile;
  int _paletteIndex = 0;

  final List<Map<String, dynamic>> _catalogData =
      (_mockScreenJson['data'] as List).cast<Map<String, dynamic>>();

  late final List<GlobalKey> _itemKeys = List.generate(
    _catalogData.length,
    (_) => GlobalKey(),
  );

  late final List<_CatalogEntry> _sidebarEntries = [
    for (var i = 0; i < _catalogData.length; i++)
      if (_catalogData[i]['type'] != 'DIVIDER')
        _CatalogEntry(index: i, label: _labelFor(_catalogData[i])),
  ];

  late final _callbacks = WidgetCallbacks(
    onAction: (action) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Action: ${action.type.name} id=${action.id ?? action.goto ?? '-'}',
        ),
      ),
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
        video:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        action: WidgetAction(type: WidgetActionType.category, id: 1),
      ),
    ],
    fetchModal: (id) async => 'https://picsum.photos/seed/modal$id/600/800',
    isLoggedIn: () => _isLoggedIn,
    onRequireAuth: () => ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('You need to log in'))),
    onToggleFavorite: (product) async {
      final updated = !product.isFavorited;
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1)
          _products[index] = product.copyWith(isFavorited: updated);
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

  void _scrollToIndex(int index) {
    final ctx = _itemKeys[index].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenData = WidgetCatalog.fromJson(_mockScreenJson);
    final widgets = WidgetCatalog.getScreen(
      data: screenData,
      callbacks: _callbacks,
      theme: _palettes[_paletteIndex].theme,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Serenay E-commerce Widgets'),
        actions: [
          TextButton.icon(
            onPressed: () => launchUrl(
              Uri.parse(
                'https://serenayyazilim.github.io/serenay-ecommerce-widgets/docs/',
              ),
              webOnlyWindowName: '_blank',
            ),
            icon: const Icon(Icons.menu_book_outlined, color: Colors.white),
            label: const Text('Docs', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Sidebar(entries: _sidebarEntries, onTap: _scrollToIndex),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _Toolbar(
                  device: _device,
                  onDeviceChanged: (d) => setState(() => _device = d),
                  paletteIndex: _paletteIndex,
                  onPaletteChanged: (i) => setState(() => _paletteIndex = i),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Container(
                    color: const Color(0xFFEFF1F4),
                    child: _PreviewArea(
                      device: _device,
                      itemKeys: _itemKeys,
                      widgets: widgets,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogEntry {
  const _CatalogEntry({required this.index, required this.label});
  final int index;
  final String label;
}

const _catalogLabels = {
  'TEXT': 'Text',
  'SEARCH': 'Search',
  'SLIDER': 'Slider',
  'STORY': 'Story',
  'CAROUSEL': 'Carousel',
  'FLASHSALE': 'Flash sale',
  'IMAGE': 'Image',
  'IMAGELIST': 'Image list',
  'IMAGECAROUSEL': 'Image carousel',
  'GRID': 'Grid',
  'PRODUCTCARD': 'Product card',
  'MIXEDCAROUSEL': 'Mixed carousel',
  'VISITEDPRODUCTS': 'Visited products',
  'TIMEIMAGE': 'Time image',
  'YOUTUBE': 'YouTube',
  'VIDEOLIST': 'Video list',
  'FASTREGISTER': 'Fast register',
  'MODAL': 'Modal',
};

String _labelFor(Map<String, dynamic> item) {
  final type = item['type'] as String;
  if (type == 'TEXT') {
    final params = (item['params'] as Map?) ?? {};
    final text = params['text'];
    if (text is String && text.isNotEmpty) return text;
  }
  return _catalogLabels[type] ?? type;
}

/// Left rail listing every widget in the mock screen; tapping an entry
/// scrolls the device-frame preview to that widget.
class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.entries, required this.onTap});

  final List<_CatalogEntry> entries;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Widgets',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final entry = entries[i];
                return InkWell(
                  onTap: () => onTap(entry.index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13.5),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Top bar: device-type switch (mobile/tablet/web) + color palette picker.
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.device,
    required this.onDeviceChanged,
    required this.paletteIndex,
    required this.onPaletteChanged,
  });

  final _DeviceType device;
  final ValueChanged<_DeviceType> onDeviceChanged;
  final int paletteIndex;
  final ValueChanged<int> onPaletteChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 12,
        children: [
          _DeviceSwitch(device: device, onChanged: onDeviceChanged),
          _PaletteSwitch(selected: paletteIndex, onChanged: onPaletteChanged),
        ],
      ),
    );
  }
}

class _DeviceSwitch extends StatelessWidget {
  const _DeviceSwitch({required this.device, required this.onChanged});

  final _DeviceType device;
  final ValueChanged<_DeviceType> onChanged;

  static const _options = [
    (_DeviceType.mobile, Icons.phone_iphone, 'Mobile'),
    (_DeviceType.tablet, Icons.tablet_mac, 'Tablet'),
    (_DeviceType.web, Icons.language, 'Web'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _options.map((opt) {
          final selected = opt.$1 == device;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onChanged(opt.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    opt.$2,
                    size: 18,
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    opt.$3,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaletteSwitch extends StatelessWidget {
  const _PaletteSwitch({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Colors',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 10),
        for (var i = 0; i < _palettes.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tooltip(
              message: _palettes[i].name,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _palettes[i].swatch,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: i == selected ? Colors.black87 : Colors.white,
                      width: i == selected ? 2.5 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: i == selected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Renders [widgets] inside a device frame that matches [device].
class _PreviewArea extends StatelessWidget {
  const _PreviewArea({
    required this.device,
    required this.itemKeys,
    required this.widgets,
  });

  final _DeviceType device;
  final List<GlobalKey> itemKeys;
  final List<Widget> widgets;

  // A plain (non-lazy) Column: the catalog is short enough (~20 items) that
  // eagerly building everything is cheap, and it guarantees every item's
  // GlobalKey has a mounted context so the sidebar can always scroll to it —
  // a lazy ListView.builder would leave far-off items unbuilt (null
  // context) until scrolled near, breaking jump-to-item navigation.
  Widget _content(EdgeInsets padding) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        children: [
          for (var i = 0; i < widgets.length; i++)
            KeyedSubtree(key: itemKeys[i], child: widgets[i]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (device) {
      case _DeviceType.web:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: _BrowserChrome(child: _content(EdgeInsets.zero)),
        );
      case _DeviceType.mobile:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: _Bezel(
              width: 390,
              height: 844,
              radius: 44,
              notch: true,
              child: _content(const EdgeInsets.only(top: 34)),
            ),
          ),
        );
      case _DeviceType.tablet:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: _Bezel(
              width: 820,
              height: 1100,
              radius: 28,
              notch: false,
              child: _content(const EdgeInsets.only(top: 16)),
            ),
          ),
        );
    }
  }
}

/// Scopes [child] to its own [Navigator] and a [MediaQuery] reporting [size]
/// as the viewport, so widgets that push full-screen routes or show
/// dialogs/bottom sheets (STORY, MODAL, variant sheets, the SLIDER zoom
/// gallery, ...) stay confined to the device frame instead of covering the
/// whole demo window.
class _DeviceScope extends StatelessWidget {
  const _DeviceScope({required this.size, required this.child});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(size: size),
      child: Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => child),
      ),
    );
  }
}

/// Phone/tablet bezel: dark rounded frame with an optional notch, clipping
/// the scrollable widget catalog inside it.
class _Bezel extends StatelessWidget {
  const _Bezel({
    required this.width,
    required this.height,
    required this.radius,
    required this.notch,
    required this.child,
  });

  final double width;
  final double height;
  final double radius;
  final bool notch;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111318),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: _DeviceScope(size: Size(width, height), child: child),
              ),
            ),
            if (notch)
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111318),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Browser-window chrome (title bar dots + address pill) used for the "Web"
/// device mode.
class _BrowserChrome extends StatelessWidget {
  const _BrowserChrome({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 40,
            color: const Color(0xFFF3F4F6),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _dot(const Color(0xFFFF5F57)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF28C840)),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 24,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E2E2)),
                    ),
                    child: const Text(
                      'serenay-ecommerce-widgets.dev',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => _DeviceScope(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );
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
    measureOptions: i == 0
        ? const [
            ProductMeasureOption(id: 's', title: 'S', priceText: '99.90 ₺'),
            ProductMeasureOption(id: 'm', title: 'M', priceText: '99.90 ₺'),
            ProductMeasureOption(id: 'l', title: 'L', priceText: '109.90 ₺'),
          ]
        : const [],
    saleDisabled: i == 5,
    saleDisabledReason: i == 5 ? 'Out of stock' : null,
    preOrder: i == 3,
  ),
);

final _mockScreenJson = {
  'data': [
    {
      'type': 'TEXT',
      'params': {
        'text': 'Serenay E-commerce Widgets',
        'style': 'section',
        'subtitle': 'Full widget catalog',
      },
    },
    {
      'type': 'SEARCH',
      'params': {
        'hint_text': 'Search products, brands...',
        'url': 'https://picsum.photos/seed/searchbg/800/400',
        'height_percent': 0.35,
      },
    },
    {
      'type': 'MIXEDCAROUSEL',
      'params': {
        'height_percent': 1.0,
        'items': [
          {
            'item_type': 'image',
            'bg_color': '#222222',
            'title': 'Lowest Price of the Year',
            'title_color': '#FFFFFF',
            'url': 'https://picsum.photos/seed/mix1/800/800',
            'type': 'category',
            'id': 1,
          },
          {
            'item_type': 'products',
            'bg_color': '#FFF7EC',
            'title': 'Just For You',
            'title_color': '#000000',
            'description':
                'Hand-picked products based on your browsing history',
            'description_color': '#000000',
            'category_id': 1,
          },
        ],
      },
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
          {
            'url': 'https://picsum.photos/seed/il1/400/200',
            'type': 'category',
            'id': 1,
          },
          {
            'url': 'https://picsum.photos/seed/il2/400/200',
            'type': 'category',
            'id': 2,
          },
        ],
      },
    },
    {
      'type': 'IMAGECAROUSEL',
      'params': {
        'id': 2,
        'height_percent': 0.35,
        'item_count': 2,
        'bg_image': '',
      },
    },
    {'type': 'DIVIDER', 'params': {}},
    {
      'type': 'TEXT',
      'params': {'text': 'All Products', 'style': 'section'},
    },
    {
      'type': 'SLIDER',
      'params': {'id': 1, 'height_percent': 0.35},
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
    {'type': 'FASTREGISTER', 'params': {}},
    {
      'type': 'MODAL',
      'params': {
        'url': 'https://picsum.photos/seed/modalwelcome/600/800',
        'type': 'category',
        'id': 1,
      },
    },
    {'type': 'UNKNOWN_FUTURE_TYPE', 'params': {}},
  ],
};
