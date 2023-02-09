import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class InternetNotConnected extends Mock implements Connectivity {
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return Stream<ConnectivityResult>.fromIterable(
      [
        ConnectivityResult.none,
      ],
    );
  }
}

class InternetConnected extends Mock implements Connectivity {
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return Stream<ConnectivityResult>.fromIterable(
      [
        ConnectivityResult.mobile,
        ConnectivityResult.wifi,
        ConnectivityResult.bluetooth,
        ConnectivityResult.ethernet,
      ],
    );
  }
}

void main() {
  // group('FlutterInternetWidget', () {
  //   testWidgets('test custom online screen', (WidgetTester tester) async {
  //     await tester.pumpWidget(AppWidget(connectivity: InternetConnected()));
  //     await tester.pump(const Duration(seconds: 1));
  //     expect(
  //       find.byWidgetPredicate(
  //         (widget) =>
  //
  //widget is Text && widget.data == 'Connected to internet - test',
  //       ),
  //       findsOneWidget,
  //     );
  //   });
  // });
  group('FlutterNoInternetWidget', () {
    test('can be instantiated', () {
      expect(
        InternetWidget(
          online: Container(),
        ),
        isNotNull,
      );
    });

    testWidgets(
      'Pump FlutterNoInternetWidget',
      (WidgetTester tester) async {
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
      },
    );

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
      const loadingWidget = Center(
        child: CircularProgressIndicator(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: InternetWidget(
            online: Container(),
            loadingWidget: loadingWidget,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is InternetWidget &&
              widget.loadingWidget != null &&
              widget.loadingWidget == loadingWidget,
        ),
        findsOneWidget,
      );
    });

    testWidgets('test custom offline screen', (WidgetTester tester) async {
      await tester.pumpWidget(AppWidget(connectivity: InternetNotConnected()));
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'No Internet - test',
        ),
        findsOneWidget,
      );
    });
  });
}

class AppWidget extends StatefulWidget {
  const AppWidget({
    super.key,
    this.connectivity,
  });
  final Connectivity? connectivity;

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      connectivity: widget.connectivity ?? InternetNotConnected(),
      offline: const FullScreenWidget(
        child: Center(child: Text('No Internet - test')),
      ),
      online: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Center(child: Text('Connected to internet - test')),
      ),
    );
  }
}
