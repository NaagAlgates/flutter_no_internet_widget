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

    testWidgets('test default offline screen', (WidgetTester tester) async {
      await tester.pumpWidget(const AppWidgets());
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'No Internet',
        ),
        findsOneWidget,
      );
    });
  });
}

class AppWidgets extends StatefulWidget {
  const AppWidgets({
    Key? key,
    this.connectivity,
  }) : super(key: key);
  final Connectivity? connectivity;

  @override
  State<AppWidgets> createState() => _AppWidgetsState();
}

class _AppWidgetsState extends State<AppWidgets> {
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      connectivity: widget.connectivity ?? InternetNotConnected(),
      offline: const Center(child: Text('No Internet')),
      // ignore: avoid_print
      whenOffline: () => print('No Internet'),
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      online: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Center(child: Text('Connected to internet')),
      ),
    );
  }
}
