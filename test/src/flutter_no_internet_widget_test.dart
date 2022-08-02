import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterNoInternetWidget', () {
    test('can be instantiated', () {
      expect(
        InternetWidget(
          online: Container(),
        ),
        isNotNull,
      );
    });

    testWidgets('Pump FlutterNoInternetWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InternetWidget(
            online: Container(),
          ),
        ),
      );

      expect(
        find.byType(InternetWidget),
        findsOneWidget,
        reason: 'Load the widgets',
      );
    });

    testWidgets('lookupUrl', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InternetWidget(
            online: Container(),
            lookupUrl: 'www.example.com',
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is InternetWidget &&
              widget.lookupUrl != null &&
              widget.lookupUrl!.contains('www.example.com'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('loadingWidget', (WidgetTester tester) async {
      const _loadingWidget = Center(
        child: CircularProgressIndicator(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: InternetWidget(
            online: Container(),
            loadingWidget: _loadingWidget,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is InternetWidget &&
              widget.loadingWidget != null &&
              widget.loadingWidget == _loadingWidget,
        ),
        findsOneWidget,
      );
    });
  });
}
