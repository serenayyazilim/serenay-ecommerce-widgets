import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:serenay_ecommerce_widgets/serenay_ecommerce_widgets.dart';

WidgetCallbacks _callbacks({
  void Function(WidgetAction action)? onAction,
  Future<List<ProductCardData>> Function(ProductQuery query)? fetchProducts,
  bool Function()? isLoggedIn,
  Future<List<SlideItem>> Function(dynamic id)? fetchSlides,
  List<ProductCardData> Function()? visitedProducts,
}) {
  return WidgetCallbacks(
    onAction: onAction ?? (_) {},
    fetchProducts: fetchProducts ?? (_) async => const [],
    isLoggedIn: isLoggedIn,
    fetchSlides: fetchSlides,
    visitedProducts: visitedProducts,
  );
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
}
