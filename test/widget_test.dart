import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_ecommerce_widgets/mobile_ecommerce_widgets.dart';

WidgetCallbacks _callbacks({
  void Function(WidgetAction action)? onAction,
  Future<List<ProductCardData>> Function(ProductQuery query)? fetchProducts,
}) {
  return WidgetCallbacks(
    onAction: onAction ?? (_) {},
    fetchProducts: fetchProducts ?? (_) async => const [],
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
}
