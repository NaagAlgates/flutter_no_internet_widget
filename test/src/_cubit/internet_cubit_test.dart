import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_no_internet_widget/src/_cubit/internet_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {
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

class MockDisconnection extends Mock implements Connectivity {
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return Stream<ConnectivityResult>.fromIterable(
      [
        ConnectivityResult.none,
      ],
    );
  }
}

void main() {
  group(
    'Test internet connectivity cubit',
    () {
      final _internetCubit = InternetCubit(connectivity: MockConnectivity());
      test('When mobile connected', () {
        expect(
          _internetCubit.state,
          const InternetState(
            internetStatus: InternetStatus.connected,
          ),
        );
      });
    },
  );
  group(
    'Test no connectivity cubit',
    () {
      late final InternetCubit _internetCubit;
      setUp(() {
        _internetCubit = InternetCubit(connectivity: MockDisconnection());
      });
      test('When mobile disconnected', () {
        expect(
          _internetCubit.state,
          const InternetState(
            internetStatus: InternetStatus.disconnected,
          ),
        );
      });
    },
  );
  group(
    'Test dispose',
    () {
      late final InternetCubit _internetCubit;
      _internetCubit = InternetCubit(connectivity: MockDisconnection());

      test('dispose', () {
        expect(
          _internetCubit.dispose,
          returnsNormally,
        );
      });
    },
  );
}
