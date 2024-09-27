import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:juice_drinker/objects/juice.dart';
import 'package:juice_drinker/main.dart';
import 'package:juice_drinker/pages/juice_page.dart';
import 'package:juice_drinker/pages/shop_page.dart';
import 'package:juice_drinker/widgets/juice_widget.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

void main() {
  group('Juice Class Tests', () {
    test('Juice constructor should correctly initialize properties', () {
      final juice =
          Juice(color: Colors.orange, name: 'Orange Juice', price: 20);

      expect(juice.color, equals(Colors.orange));
      expect(juice.name, equals('Orange Juice'));
      expect(juice.price, equals(20));
      expect(juice.purchased, isFalse);
    });
  });

  group('HomePage Widget Tests', () {
    testWidgets('HomePage should initialize with JuicePage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      expect(find.byType(JuicePage), findsOneWidget);
      expect(find.byType(ShopPage), findsNothing);
    });

    testWidgets('Tapping shop tab should show ShopPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      await tester.tap(find.byIcon(Icons.shopping_basket_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(ShopPage), findsOneWidget);
      expect(find.byType(JuicePage), findsNothing);
    });
  });

  group('JuicePage Widget Tests', () {
    testWidgets('JuicePage should pass correct juice to JuiceWidget',
        (WidgetTester tester) async {
      final testJuice =
          Juice(color: Colors.orange, name: 'Test Juice', price: 10);
      await tester.pumpWidget(MaterialApp(
        home: JuicePage(juice: testJuice, onCoinUpdate: (_) {}),
      ));

      // Find the JuiceWidget
      final juiceWidgetFinder = find.byType(JuiceWidget);
      expect(juiceWidgetFinder, findsOneWidget);

      // Verify that the JuiceWidget has the correct juice
      final juiceWidget = tester.widget<JuiceWidget>(juiceWidgetFinder);
      expect(juiceWidget.juice, equals(testJuice));

      // If you want to verify the name specifically
      expect(juiceWidget.juice.name, equals('Test Juice'));
    });

    testWidgets('JuicePage should have a LiquidLinearProgressIndicator',
        (WidgetTester tester) async {
      final testJuice =
          Juice(color: Colors.orange, name: 'Test Juice', price: 10);
      await tester.pumpWidget(MaterialApp(
        home: JuicePage(juice: testJuice, onCoinUpdate: (_) {}),
      ));

      expect(find.byType(LiquidLinearProgressIndicator), findsOneWidget);
    });
  });

  group('ShopPage Widget Tests', () {
    testWidgets('ShopPage should display available juices',
        (WidgetTester tester) async {
      final allJuices = [
        Juice(color: Colors.orange, name: 'Orange Juice', price: 20),
        Juice(color: Colors.purple, name: 'Grape Juice', price: 20),
      ];

      await tester.pumpWidget(MaterialApp(
        home: ShopPage(
          onJuiceUpdate: (_) {},
          coins: 50,
          onCoinUpdate: (_) {},
          onPurchase: (_) {},
          purchasedJuices: [],
          allJuices: allJuices,
        ),
      ));

      expect(find.text('Orange Juice'), findsOneWidget);
      expect(find.text('Buy for 20 coins'), findsOneWidget);
    });

    testWidgets('Tapping next juice should show next juice',
        (WidgetTester tester) async {
      final allJuices = [
        Juice(color: Colors.orange, name: 'Orange Juice', price: 20),
        Juice(color: Colors.purple, name: 'Grape Juice', price: 20),
      ];

      await tester.pumpWidget(MaterialApp(
        home: ShopPage(
          onJuiceUpdate: (_) {},
          coins: 50,
          onCoinUpdate: (_) {},
          onPurchase: (_) {},
          purchasedJuices: [],
          allJuices: allJuices,
        ),
      ));

      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pump();

      expect(find.text('Grape Juice'), findsOneWidget);
      expect(find.text('Buy for 20 coins'), findsOneWidget);
    });
  });
}
