import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:serenay_ecommerce_widgets/serenay_ecommerce_widgets.dart';
import 'package:serenay_ecommerce_widgets/src/core/utils/param_parsing.dart';

WidgetCallbacks _callbacks({
  void Function(WidgetAction action)? onAction,
  Future<List<ProductCardData>> Function(ProductQuery query)? fetchProducts,
  bool Function()? isLoggedIn,
  Future<List<SlideItem>> Function(dynamic id)? fetchSlides,
  List<ProductCardData> Function()? visitedProducts,
  Future<void> Function(ProductCardData product, ProductVariant? variant, int quantity)?
  onAddToCart,
  String Function(num amount, String currency)? formatPrice,
  Widget Function(ProductCardData data)? productCardBuilder,
  Widget Function()? imageErrorBuilder,
}) {
  return WidgetCallbacks(
    onAction: onAction ?? (_) {},
    fetchProducts: fetchProducts ?? (_) async => const [],
    isLoggedIn: isLoggedIn,
    fetchSlides: fetchSlides,
    visitedProducts: visitedProducts,
    onAddToCart: onAddToCart,
    formatPrice: formatPrice,
    productCardBuilder: productCardBuilder,
    imageErrorBuilder: imageErrorBuilder,
  );
}

/// Pumps [entries] through [WidgetCatalog.getScreen] inside a [width]-wide
/// column.
Future<void> _pumpScreen(
  WidgetTester tester,
  List<Map<String, dynamic>> entries, {
  WidgetCallbacks? callbacks,
  double width = 400,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: WidgetCatalog.getScreen(
                data: WidgetCatalog.fromJson({'data': entries}),
                callbacks: callbacks ?? _callbacks(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('WidgetEntry.listFromJson parses the backend {data: []} shape', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'TEXT', 'params': {'text': 'Hello'}},
        {'type': 'DIVIDER', 'params': {}},
        {'type': 'NOT_A_REAL_TYPE', 'params': {}},
      ],
    });

    expect(data, hasLength(3));
    expect(data[0].type, WidgetType.text);
    expect(data[1].type, WidgetType.divider);
    expect(data[2].type, WidgetType.unknown);
  });

  testWidgets('WidgetEntry accepts params as a JSON-encoded string', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'TEXT', 'params': '{"text":"From string"}'},
      ],
    });

    expect(data.single.params['text'], 'From string');
  });

  testWidgets('TEXT and DIVIDER render through getScreen', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'TEXT', 'params': {'text': 'Section title'}},
        {'type': 'DIVIDER', 'params': {'height': 20}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(find.text('Section title'), findsOneWidget);
  });

  testWidgets('unknown widget type renders as an empty 1px box, never a crash', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'SOMETHING_FROM_THE_FUTURE', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('IMAGE tap resolves through the shared action contract', (tester) async {
    WidgetAction? tapped;
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'IMAGE',
          'params': {'url': '', 'type': 'category', 'id': 42},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(onAction: (action) => tapped = action),
            ),
          ),
        ),
      ),
    );

    await tester.tap(
      find.byWidgetPredicate((widget) => widget is GestureDetector && widget.onTap != null),
    );
    await tester.pump();

    expect(tapped?.type, WidgetActionType.category);
    expect(tapped?.id, 42);
  });

  testWidgets('CAROUSEL builds its ProductQuery from params and fetches products', (
    tester,
  ) async {
    ProductQuery? query;
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'CAROUSEL',
          'params': {'category_id': 7, 'limit': 10},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (q) async {
                  query = q;
                  return const [
                    ProductCardData(id: 1, image: '', title: 'P1', price: 10),
                  ];
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(query?.categoryId, 7);
    expect(find.text('P1'), findsOneWidget);
  });

  testWidgets('CAROUSEL autoplay auto-scrolls the row on a timer', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'CAROUSEL',
          'params': {'category_id': 7, 'autoplay': 1, 'autoplay_interval': 1},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'P1', price: 10),
                  ProductCardData(id: 2, image: '', title: 'P2', price: 10),
                  ProductCardData(id: 3, image: '', title: 'P3', price: 10),
                  ProductCardData(id: 4, image: '', title: 'P4', price: 10),
                  ProductCardData(id: 5, image: '', title: 'P5', price: 10),
                  ProductCardData(id: 6, image: '', title: 'P6', price: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final listView = tester.widget<ListView>(find.byType(ListView));
    final controller = listView.controller!;
    expect(controller.offset, 0);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));

    expect(controller.offset, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('CAROUSEL does not autoplay with fewer than two products', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'CAROUSEL',
          'params': {'category_id': 7, 'autoplay': 1, 'autoplay_interval': 1},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'P1', price: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
  });

  testWidgets('getScreen(theme:) overrides the price color rendered by CAROUSEL', (
    tester,
  ) async {
    const customColor = Color(0xFF123456);
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'CAROUSEL', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'P1', price: 10),
                ],
              ),
              theme: const EcommerceWidgetTheme(textPrimaryColor: customColor),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final priceText = tester.widget<Text>(find.text('10.00 ₺'));
    expect(priceText.style?.color, customColor);
  });

  testWidgets('numeric params tolerate backend strings (e.g. "20" instead of 20)', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'DIVIDER',
          'params': {'height': '20'},
        },
        {
          'type': 'TEXT',
          'params': {'text': 'Hi', 'padding_horizontal': '5', 'padding_vertical': '5'},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Hi'), findsOneWidget);
  });

  testWidgets('theme.viewPricesLabel overrides the logged-out price prompt', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 160,
            child: RichProductCard(
              data: const ProductCardData(id: 1, image: '', title: 'P1', price: 10),
              callbacks: _callbacks(isLoggedIn: () => false),
              theme: const EcommerceWidgetTheme(viewPricesLabel: 'Show Prices'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Show Prices'), findsOneWidget);
    expect(find.text('View Prices'), findsNothing);
  });

  testWidgets('MiniProductTile renders with a theme-colored card background', (tester) async {
    const surfaceColor = Color(0xFFEFEFEF);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MiniProductTile(
            data: const ProductCardData(id: 1, image: '', title: 'P1', price: 10),
            callbacks: _callbacks(),
            theme: const EcommerceWidgetTheme(surfaceColor: surfaceColor),
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.ancestor(of: find.text('P1'), matching: find.byType(Container)).first,
    );
    expect((container.decoration as BoxDecoration?)?.color, surfaceColor);
  });

  testWidgets('getScreen(theme:) overrides FASTREGISTER and FLASHSALE labels', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'FASTREGISTER', 'params': {}},
        {
          'type': 'FLASHSALE',
          'params': {},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(),
              theme: const EcommerceWidgetTheme(
                fastRegisterTitleLabel: 'Hızlı Kayıt',
                flashSaleTitleLabel: 'Süper Fırsat',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Hızlı Kayıt'), findsOneWidget);
    expect(find.text('Quick Registration System'), findsNothing);
    expect(find.text('Süper Fırsat'), findsOneWidget);
    expect(find.text('Flash Sale'), findsNothing);
  });

  testWidgets('FLASHSALE display_mode "inline" renders products in a horizontal list without a tap',
      (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'FLASHSALE',
          'params': {'title': 'Flash', 'display_mode': 'inline'},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'F1', price: 10),
                  ProductCardData(id: 2, image: '', title: 'F2', price: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('F1'), findsOneWidget);
    expect(find.text('F2'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    // Tapping the bar should not open the bottom-sheet modal in inline mode.
    await tester.tap(find.text('Flash'));
    await tester.pump();
    expect(find.byType(DraggableScrollableSheet), findsNothing);
  });

  testWidgets('timed widgets hide on an unparseable end_time but show when end_time is omitted', (tester) async {
    // Each entry renders its `label` as visible text.
    const cases = {
      'FLASHSALE': 'title',
      'COUPON': 'code',
      'URGENCY': 'text',
      'ABANDONEDCART': 'title',
    };
    await _pumpScreen(
      tester,
      [
        for (final MapEntry(key: type, value: field) in cases.entries) ...[
          {
            'type': type,
            'params': {field: '$type bad', 'end_time': 'next friday'},
          },
          {
            'type': type,
            'params': {field: '$type open'},
          },
        ],
      ],
      callbacks: _callbacks(
        fetchProducts: (_) async => const [ProductCardData(id: 1, image: '', title: 'P1', price: 10)],
      ),
    );
    await tester.pump();

    for (final type in cases.keys) {
      expect(find.text('$type bad'), findsNothing, reason: type);
      expect(find.text('$type open'), findsOneWidget, reason: type);
    }
  });

  testWidgets('FLASHSALE defaults to modal mode: products are not fetched until tapped', (tester) async {
    var fetchCount = 0;
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'FLASHSALE',
          'params': {'title': 'Flash'},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async {
                  fetchCount++;
                  return const [ProductCardData(id: 1, image: '', title: 'M1', price: 10)];
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(fetchCount, 0);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('TIMEIMAGE never crashes on a malformed backend title_color', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'TIMEIMAGE',
          'params': {
            'url': 'https://example.com/banner.png',
            'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
            'title': 'Countdown',
            'title_color': 'not-a-color',
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Countdown'), findsOneWidget);
  });

  testWidgets('SEARCH bar reads its background from the theme instead of hardcoded white', (
    tester,
  ) async {
    const surfaceColor = Color(0xFF222222);
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'SEARCH', 'params': {'url': ''}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(),
              theme: const EcommerceWidgetTheme(surfaceColor: surfaceColor),
            ),
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.ancestor(of: find.byType(TextField), matching: find.byType(Container)).first,
    );
    expect((container.decoration as BoxDecoration?)?.color, surfaceColor);
  });

  testWidgets('FASTREGISTER reads its accent color from the theme instead of hardcoded green', (
    tester,
  ) async {
    const accent = Color(0xFF9C27B0);
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'FASTREGISTER', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(),
              theme: const EcommerceWidgetTheme(fastRegisterAccentColor: accent),
            ),
          ),
        ),
      ),
    );

    final title = tester.widget<Text>(find.text('Quick Registration System'));
    expect(title.style?.color, accent);
  });

  testWidgets('MODAL shows its dialog once per session, and ModalWidget.resetShown() clears that', (
    tester,
  ) async {
    ModalWidget.resetShown();
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'MODAL',
          'params': {'url': '', 'type': 'category', 'id': 'promo-1'},
        },
      ],
    });

    // pumpWidget alone reuses the same Element (didUpdateWidget) when the
    // tree shape doesn't change, which wouldn't re-run initState. Pumping an
    // empty tree in between forces a genuine unmount + remount, simulating
    // a fresh screen instance.
    Future<void> pumpOnce() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
            ),
          ),
        ),
      );
    }

    await pumpOnce();
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();

    // Same key, freshly-mounted widget: should NOT show again this session.
    await pumpOnce();
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);

    // After resetShown(), the same key shows again.
    ModalWidget.resetShown();
    await pumpOnce();
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('MIXEDCAROUSEL renders an image page without crashing', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'MIXEDCAROUSEL',
          'params': {
            'items': [
              {'item_type': 'image', 'url': '', 'title': 'Page 1'},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Page 1'), findsOneWidget);
  });

  testWidgets('STORY renders its list without crashing', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'STORY',
          'params': {
            'list': [
              {'image': '', 'title': 'Story 1'},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('SLIDER fetches slides by id and renders without crashing', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'SLIDER',
          'params': {'id': 5},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchSlides: (_) async => const [
                  SlideItem(image: '', action: WidgetAction(type: WidgetActionType.category, id: 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('SLIDER reads viewport_fraction and item_padding_horizontal from params', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'SLIDER',
          'params': {'id': 5, 'viewport_fraction': 1.0, 'item_padding_horizontal': 0},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchSlides: (_) async => const [
                  SlideItem(image: '', action: WidgetAction(type: WidgetActionType.category, id: 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller?.viewportFraction, 1.0);

    final padding = tester.widget<Padding>(
      find.ancestor(of: find.byType(GestureDetector), matching: find.byType(Padding)).first,
    );
    expect(padding.padding, EdgeInsets.zero);

    expect(tester.takeException(), isNull);
  });

  testWidgets('SLIDER autoplay advances pages on a timer', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'SLIDER',
          'params': {'id': 5, 'autoplay': 1, 'autoplay_interval': 1},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchSlides: (_) async => const [
                  SlideItem(image: '', action: WidgetAction(type: WidgetActionType.category, id: 1)),
                  SlideItem(image: '', action: WidgetAction(type: WidgetActionType.category, id: 2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller?.page, 0);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));

    expect(pageView.controller?.page, 1);

    expect(tester.takeException(), isNull);
  });

  testWidgets('SLIDER does not autoplay with fewer than two slides', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'SLIDER',
          'params': {'id': 5, 'autoplay': 1, 'autoplay_interval': 1},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchSlides: (_) async => const [
                  SlideItem(image: '', action: WidgetAction(type: WidgetActionType.category, id: 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
  });

  testWidgets('VISITEDPRODUCTS renders the host app-supplied history without crashing', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'VISITEDPRODUCTS', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                visitedProducts: () => const [
                  ProductCardData(id: 1, image: '', title: 'Visited 1', price: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Visited 1'), findsOneWidget);
  });

  testWidgets('RATING renders its stars and review count without crashing', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'RATING',
          'params': {'rating': 3.5, 'review_count': 128},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('3.5'), findsOneWidget);
    expect(find.text('(128)'), findsOneWidget);
  });

  testWidgets('BUNDLE fetches products and renders an Add All to Cart button', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'BUNDLE',
          'params': {'is_bundle_product': true},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'B1', price: 10),
                  ProductCardData(id: 2, image: '', title: 'B2', price: 20),
                ],
                onAddToCart: (product, variant, quantity) async {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('B1'), findsOneWidget);
    expect(find.text('B2'), findsOneWidget);
    expect(find.text('Add All to Cart'), findsOneWidget);
  });

  testWidgets('COUPON shows the code and hides itself once end_time has passed', (tester) async {
    final active = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'COUPON',
          'params': {'code': 'SAVE20', 'discount_text': '20% OFF'},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: active, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(find.text('SAVE20'), findsOneWidget);

    final expired = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'COUPON',
          'params': {
            'code': 'OLD10',
            'end_time': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          },
        },
      ],
    });

    // Pump an empty tree first so the next pumpWidget is a genuine
    // unmount + remount (a same-shape rebuild would reuse the State via
    // didUpdateWidget instead of re-reading params through initState).
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: expired, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(find.text('OLD10'), findsNothing);
  });

  testWidgets('CATEGORYMENU renders category items and resolves taps through onAction', (
    tester,
  ) async {
    WidgetAction? tapped;
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'CATEGORYMENU',
          'params': {
            'list': [
              {'title': 'Shoes', 'image': '', 'type': 'category', 'id': 9},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(onAction: (action) => tapped = action),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Shoes'), findsOneWidget);
    await tester.tap(find.text('Shoes'));
    await tester.pump();

    expect(tapped?.type, WidgetActionType.category);
    expect(tapped?.id, 9);
  });

  testWidgets('LOYALTYPROGRESS renders its title and reward text without crashing', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'LOYALTYPROGRESS',
          'params': {
            'current': 2,
            'target': 5,
            'title': 'Free Shipping Progress',
            'reward_text': '3 more orders to go',
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Free Shipping Progress'), findsOneWidget);
    expect(find.text('3 more orders to go'), findsOneWidget);
  });

  testWidgets('COMPARISON renders at least two fetched products side by side', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'COMPARISON', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'C1', price: 10),
                  ProductCardData(id: 2, image: '', title: 'C2', price: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('C1'), findsOneWidget);
    expect(find.text('C2'), findsOneWidget);
  });

  testWidgets('ABANDONEDCART renders fetched products and a CTA that resolves through onAction', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'ABANDONEDCART',
          'params': {'cart_id': 42, 'goto': 'cart'},
        },
      ],
    });

    WidgetAction? resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'A1', price: 10),
                ],
                onAction: (action) => resolved = action,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('You left items in your cart'), findsOneWidget);
    expect(find.text('Complete your order'), findsOneWidget);

    await tester.tap(find.text('Complete your order'));
    expect(resolved?.goto, 'cart');
  });

  testWidgets('ABANDONEDCART hides itself once end_time has passed', (tester) async {
    final expired = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'ABANDONEDCART',
          'params': {
            'end_time': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: expired,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'A1', price: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A1'), findsNothing);
  });

  testWidgets('REVIEWS renders an inline list of reviews with average rating and verified badge', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'REVIEWS',
          'params': {
            'average_rating': 4.5,
            'review_count': 128,
            'list': [
              {
                'author': 'Alice',
                'rating': 5,
                'comment': 'Loved it!',
                'verified': true,
              },
              {'author': 'Bob', 'rating': 3, 'comment': 'It was okay.'},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Customer Reviews'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(128)'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Loved it!'), findsOneWidget);
    expect(find.text('Verified Purchase'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('REVIEWS hides itself when the list is empty', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'REVIEWS', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Customer Reviews'), findsNothing);
  });

  testWidgets('QNA renders an inline list of question/answer entries', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'QNA',
          'params': {
            'list': [
              {'question': 'Does this run small?', 'answer': 'True to size.', 'author': 'Dana'},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Questions & Answers'), findsOneWidget);
    expect(find.text('Does this run small?'), findsOneWidget);
    expect(find.text('True to size.'), findsOneWidget);
  });

  testWidgets('QNA hides itself when the list is empty', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'QNA', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Questions & Answers'), findsNothing);
  });

  testWidgets('URGENCY builds its low-stock text from stock_left and hides above threshold', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'URGENCY',
          'params': {'stock_left': 3},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Only 3 left in stock!'), findsOneWidget);

    final aboveThreshold = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'URGENCY',
          'params': {'stock_left': 50},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: aboveThreshold, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('left in stock'), findsNothing);
  });

  testWidgets('RECOMMENDEDFORYOU fetches products and renders a title header', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'RECOMMENDEDFORYOU', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'R1', price: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Recommended For You'), findsOneWidget);
    expect(find.text('R1'), findsOneWidget);
  });

  testWidgets('SOCIALPROOF builds its text from count and hides when there is nothing to show', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'SOCIALPROOF',
          'params': {'count': 47},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('47 people bought this recently'), findsOneWidget);

    final empty = WidgetCatalog.fromJson({
      'data': [
        {'type': 'SOCIALPROOF', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: empty, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('47 people bought this recently'), findsNothing);
  });

  testWidgets('SIZEGUIDE opens a dialog with the headers/rows table on tap', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'SIZEGUIDE',
          'params': {
            'headers': ['Size', 'Chest'],
            'rows': [
              ['M', '96-100cm'],
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Size Guide'), findsOneWidget);
    expect(find.text('96-100cm'), findsNothing);

    await tester.tap(find.text('Size Guide'));
    await tester.pumpAndSettle();

    expect(find.text('96-100cm'), findsOneWidget);
  });

  testWidgets('TRUSTBADGES renders an inline list of reassurance icons', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'TRUSTBADGES',
          'params': {
            'list': [
              {'icon': 'shipping', 'label': 'Free Shipping'},
              {'icon': 'secure', 'label': 'Secure Payment'},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Free Shipping'), findsOneWidget);
    expect(find.text('Secure Payment'), findsOneWidget);
  });

  testWidgets('GRID (OldProductCard) renders fetched products without crashing', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'GRID', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'Grid P1', price: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Grid P1'), findsOneWidget);
  });

  testWidgets('formatPrice callback overrides the default "<amount> <symbol>" text', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'CAROUSEL', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'P1', price: 10, currency: 'usd'),
                ],
                formatPrice: (amount, currency) => '£${amount.toInt()}',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('£10'), findsOneWidget);
  });

  testWidgets('productCardBuilder overrides CAROUSEL\'s default RichProductCard', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'CAROUSEL', 'params': {}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'P1', price: 10),
                ],
                productCardBuilder: (data) => Text('Custom card: ${data.title}'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Custom card: P1'), findsOneWidget);
    expect(find.text('P1'), findsNothing);
  });

  testWidgets('GRID reads its column count from params over the theme default', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'GRID',
          'params': {'columns': 3},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                fetchProducts: (_) async => const [
                  ProductCardData(id: 1, image: '', title: 'Grid P1', price: 20),
                  ProductCardData(id: 2, image: '', title: 'Grid P2', price: 20),
                  ProductCardData(id: 3, image: '', title: 'Grid P3', price: 20),
                ],
              ),
              theme: const EcommerceWidgetTheme(gridColumns: 2),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Grid P3'), findsOneWidget);
  });

  testWidgets('WidgetCatalog.registerBuilder renders a custom widget for an unknown type', (
    tester,
  ) async {
    WidgetCatalog.registerBuilder(
      'CUSTOM_BANNER',
      (entry, callbacks, theme) => Text(entry.params['text'] as String? ?? ''),
    );
    addTearDown(() => WidgetCatalog.unregisterBuilder('CUSTOM_BANNER'));

    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'CUSTOM_BANNER',
          'params': {'text': 'Hello from host app'},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    expect(find.text('Hello from host app'), findsOneWidget);
  });

  testWidgets('imageErrorBuilder overrides the default broken-image placeholder', (
    tester,
  ) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'IMAGE',
          'params': {'url': 'https://example.invalid/broken.png'},
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(
              data: data,
              callbacks: _callbacks(
                imageErrorBuilder: () => const Text('custom error placeholder'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('custom error placeholder'), findsOneWidget);
  });

  test("WidgetAction.fromParams tolerates numeric string fields", () {
    final action = WidgetAction.fromParams({"type": "link", "goto": 0, "title": 5, "url": 7});
    expect(action.goto, "0");
    expect(action.title, "5");
    expect(action.url, "7");
  });

  testWidgets('IMAGELIST ignores height_percent and keeps the image uncropped', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'IMAGELIST',
          'params': {
            'list': [
              {'id': 1, 'url': 'https://example.com/a.webp', 'type': 'main_category', 'height_percent': 0.65},
              {'id': 2, 'url': 'https://example.com/b.webp', 'type': 'main_category', 'height_percent': 0.65},
            ],
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: WidgetCatalog.getScreen(data: data, callbacks: _callbacks()),
          ),
        ),
      ),
    );

    await tester.pump();

    final images = tester.widgetList<Image>(find.byType(Image));
    expect(images, hasLength(2));
    for (final image in images) {
      expect(image.fit, BoxFit.fitWidth);
      expect(image.height, isNull);
    }
  });

  testWidgets('IMAGECAROUSEL defaults keep the 1.4.3 layout', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {'type': 'IMAGECAROUSEL', 'params': {'id': 1}},
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: Column(
              children: WidgetCatalog.getScreen(
                data: data,
                callbacks: _callbacks(
                  fetchSlides: (_) async => const [
                    SlideItem(image: 'https://example.com/a.webp', action: WidgetAction(type: WidgetActionType.category)),
                    SlideItem(image: 'https://example.com/b.webp', action: WidgetAction(type: WidgetActionType.category)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // ((400 - 2*2*5) / 2) - 5 = 185
    expect(tester.getSize(find.byType(Image).first).width, 185);
    expect(tester.widget<Image>(find.byType(Image).first).fit, BoxFit.cover);
  });

  testWidgets('IMAGECAROUSEL honors item margin, width offset, padding, radius and fit', (tester) async {
    final data = WidgetCatalog.fromJson({
      'data': [
        {
          'type': 'IMAGECAROUSEL',
          'params': {
            'id': 1,
            'item_count': '2',
            'item_margin_horizontal': 6,
            'item_width_offset': 16,
            'padding_horizontal': 0.05,
            'radius': 8,
            'fit': 'scale_down',
          },
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: Column(
              children: WidgetCatalog.getScreen(
                data: data,
                callbacks: _callbacks(
                  fetchSlides: (_) async => const [
                    SlideItem(image: 'https://example.com/a.webp', action: WidgetAction(type: WidgetActionType.category)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // row = 400 * 0.9 = 360; ((360 - 2*2*6) / 2) - 16 = 152
    expect(tester.getSize(find.byType(Image)).width, 152);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.scaleDown);
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  test('parseColor accepts #RRGGBB, RRGGBB and #AARRGGBB, falls back otherwise', () {
    expect(parseColor('#FF0000'), const Color(0xFFFF0000));
    expect(parseColor('00FF00'), const Color(0xFF00FF00));
    expect(parseColor('#800000FF'), const Color(0x800000FF));
    expect(parseColor('nope', fallback: Colors.white), Colors.white);
    expect(parseColor(123), isNull);
  });

  testWidgets('CAROUSEL honors item_width, height, spacing and bg_color', (tester) async {
    await _pumpScreen(
      tester,
      [
        {
          'type': 'CAROUSEL',
          'params': {'item_width': 120, 'height': 200, 'padding_vertical': 10, 'bg_color': '#EEEEEE'},
        },
      ],
      callbacks: _callbacks(
        fetchProducts: (_) async => const [ProductCardData(id: 1, image: '', title: 'P1', price: 10)],
        productCardBuilder: (data) => const SizedBox.expand(key: Key('card')),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('card'))), const Size(120, 200));
    final container = tester.widget<Container>(find.ancestor(of: find.byType(ListView), matching: find.byType(Container)).first);
    expect((container.decoration as BoxDecoration?)?.color ?? container.color, const Color(0xFFEEEEEE));
  });

  testWidgets('PRODUCTCARD honors spacing and padding_horizontal', (tester) async {
    await _pumpScreen(
      tester,
      [
        {
          'type': 'PRODUCTCARD',
          'params': {'columns': 2, 'spacing': 20, 'padding_horizontal': 10},
        },
      ],
      callbacks: _callbacks(
        fetchProducts: (_) async => const [ProductCardData(id: 1, image: '', title: 'P1', price: 10)],
        productCardBuilder: (data) => const SizedBox(key: Key('card'), height: 10),
      ),
    );

    // (400 - 2*10 - 20) / 2 = 180
    expect(tester.getSize(find.byKey(const Key('card'))).width, 180);
  });

  testWidgets('STORY honors size and show_title', (tester) async {
    await _pumpScreen(tester, [
      {
        'type': 'STORY',
        'params': {
          'size': 70,
          'show_title': true,
          'ring_colors': ['#000000'],
          'list': [
            {'thumbnail': '', 'title': 'New in', 'urls': []},
          ],
        },
      },
    ]);

    expect(find.text('New in'), findsOneWidget);
    expect(tester.getSize(find.byType(ClipOval)), const Size(70, 70));
  });

  testWidgets('CATEGORYMENU honors image_size, item_width and max_lines', (tester) async {
    await _pumpScreen(tester, [
      {
        'type': 'CATEGORYMENU',
        'params': {
          'image_size': 72,
          'item_width': 90,
          'max_lines': 2,
          'list': [
            {'title': 'Shoes', 'image': ''},
          ],
        },
      },
    ]);

    expect(tester.getSize(find.byType(ClipRRect)), const Size(72, 72));
    expect(tester.widget<Text>(find.text('Shoes')).maxLines, 2);
  });

  testWidgets('IMAGELIST honors spacing between images', (tester) async {
    await _pumpScreen(tester, [
      {
        'type': 'IMAGELIST',
        'params': {
          'spacing': 20,
          'list': [
            {'url': 'https://example.com/a.webp'},
            {'url': 'https://example.com/b.webp'},
          ],
        },
      },
    ]);

    // (400 - 20) / 2 = 190
    expect(tester.getSize(find.byType(Image).first).width, 190);
  });

  testWidgets('ANNOUNCEMENTBAR rotates its list and fires item actions', (tester) async {
    WidgetAction? tapped;
    await _pumpScreen(
      tester,
      [
        {
          'type': 'ANNOUNCEMENTBAR',
          'params': {
            'interval': 2,
            'list': [
              'Free shipping',
              {'text': 'Sale', 'type': 'category', 'id': 7},
            ],
          },
        },
      ],
      callbacks: _callbacks(onAction: (a) => tapped = a),
    );

    expect(find.text('Free shipping'), findsOneWidget);
    await tester.tap(find.text('Free shipping'));
    expect(tapped, isNull);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Sale'), findsOneWidget);
    await tester.tap(find.text('Sale'));
    expect(tapped?.id, 7);
  });

  testWidgets('BRANDS renders a grid with the requested columns and fires actions', (tester) async {
    WidgetAction? tapped;
    await _pumpScreen(
      tester,
      [
        {
          'type': 'BRANDS',
          'params': {
            'layout': 'grid',
            'columns': 3,
            'spacing': 10,
            'padding_horizontal': 0,
            'list': [
              {'image': '', 'type': 'brand', 'id': 1},
              {'image': '', 'type': 'brand', 'id': 2},
            ],
          },
        },
      ],
      callbacks: _callbacks(onAction: (a) => tapped = a),
    );

    // (400 - 2*10) / 3 ≈ 126.67, square tiles
    final size = tester.getSize(find.byType(AspectRatio).first);
    expect(size.width, closeTo(126.67, 0.01));
    expect(size.height, closeTo(126.67, 0.01));
    await tester.tap(find.byType(AspectRatio).last);
    expect(tapped?.type, WidgetActionType.brand);
    expect(tapped?.id, 2);
  });

  testWidgets('BANNERGRID left_big splits width by big_ratio', (tester) async {
    await _pumpScreen(tester, [
      {
        'type': 'BANNERGRID',
        'params': {
          'layout': 'left_big',
          'big_ratio': 0.6,
          'spacing': 0,
          'height_percent': 0.5,
          'list': [
            {'url': 'https://example.com/a.webp'},
            {'url': 'https://example.com/b.webp'},
            {'url': 'https://example.com/c.webp'},
          ],
        },
      },
    ]);

    final images = find.byType(Image);
    expect(tester.getSize(images.at(0)), const Size(240, 200));
    expect(tester.getSize(images.at(1)), const Size(160, 100));
  });

  testWidgets('BANNERGRID falls back to grid with fewer than three items', (tester) async {
    await _pumpScreen(tester, [
      {
        'type': 'BANNERGRID',
        'params': {
          'spacing': 0,
          'aspect_ratio': 2,
          'list': [
            {'url': 'https://example.com/a.webp'},
            {'url': 'https://example.com/b.webp'},
          ],
        },
      },
    ]);

    expect(tester.getSize(find.byType(Image).first), const Size(200, 100));
  });
}
