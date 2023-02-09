import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '../flutter_no_internet_widget_test.dart';

void main() {
  group(
    'when online',
    () {
      testWidgets(
        'Pump snackbar default widget when online',
        (WidgetTester tester) async {
          final pumpWidget = MaterialApp(
            home: InternetWidget(
              offline: const SnackbarWidget(),
              connectivity: InternetConnected(),
              online: Container(),
            ),
          );
          await tester.pumpWidget(pumpWidget);

          expect(
            find.byType(InternetWidget),
            findsOneWidget,
            reason: 'Load the widgets without snackbar',
          );
        },
      );
    },
  );

  group('when offline', () {
    testWidgets(
      'Pump snackbar default widget when offline',
      (WidgetTester tester) async {
        final pumpWidget = MaterialApp(
          home: InternetWidget(
            offline: const SnackbarWidget(),
            connectivity: InternetNotConnected(),
            online: Container(),
          ),
        );
        await tester.pumpWidget(pumpWidget);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SnackBar &&
                widget.key ==
                    const ValueKey(
                      'default-snackbar',
                    ),
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == 'Offline',
          ),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Pump TopSnackbar  widget when offline',
      (WidgetTester tester) async {
        final pumpWidget = MaterialApp(
          home: InternetWidget(
            offline: const TopSnackBar(
              SnackBar(
                duration: Duration(days: 10),
                content: Text('Custom Offline'),
                key: ValueKey(
                  'custom-snackbar',
                ),
              ),
            ),
            connectivity: InternetNotConnected(),
            online: Container(),
          ),
        );
        await tester.pumpWidget(pumpWidget);
        await tester.pumpAndSettle(const Duration(microseconds: 300));
        expect(
          find.byWidgetPredicate((widget) => widget is SnackBar),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == 'Custom Offline',
          ),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Pump snackbar default widget when offline and in Top position',
      (WidgetTester tester) async {
        final pumpWidget = MaterialApp(
          home: InternetWidget(
            offline: const SnackbarWidget(
              snackbarPosition: SnackbarPosition.top,
            ),
            connectivity: InternetNotConnected(),
            online: Container(),
          ),
        );
        await tester.pumpWidget(pumpWidget);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SnackBar &&
                widget.key ==
                    const ValueKey(
                      'default-snackbar',
                    ),
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == 'Offline',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Pump custom snackbar widget when offline ',
      (WidgetTester tester) async {
        final pumpWidget = MaterialApp(
          home: InternetWidget(
            offline: const SnackbarWidget(
              snackbar: SnackBar(
                content: Text('Custom Offline'),
                key: ValueKey(
                  'custom-snackbar',
                ),
              ),
              snackbarPosition: SnackbarPosition.top,
            ),
            connectivity: InternetNotConnected(),
            online: Container(),
          ),
        );
        await tester.pumpWidget(pumpWidget);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SnackBar &&
                widget.key ==
                    const ValueKey(
                      'custom-snackbar',
                    ),
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == 'Custom Offline',
          ),
          findsOneWidget,
        );
      },
    );
  });
}
