import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';

/// Internet Status enum
enum InternetStatus {
  /// When the status initialized or unknown
  none,

  /// When internnet is connected
  connected,

  /// When internnet is disconnected
  disconnected,
}

/// CubitStatus enum
enum CubitStatus {
  ///State is awaiting a  response
  busy,

  ///State is  none
  none,
}

///Internet State cubit
class InternetState extends Equatable {
  ///Internet State Constructor
  const InternetState({
    this.internetStatus = InternetStatus.none,
    this.cubitStatus = CubitStatus.none,
  });

  ///Internet Status enum declaration
  final InternetStatus internetStatus;

  ///CubitStatus enum declaration
  final CubitStatus cubitStatus;

  @override
  List<Object> get props => [
        internetStatus,
        cubitStatus,
      ];

  /// Update the state on state change
  InternetState copyWith({
    InternetStatus? internetStatus,
    CubitStatus? cubitStatus,
  }) {
    return InternetState(
      internetStatus: internetStatus ?? this.internetStatus,
      cubitStatus: cubitStatus ?? this.cubitStatus,
    );
  }
}

///Internet State cubit
class InternetCubit extends Cubit<InternetState> {
  ///Internet State cubit
  InternetCubit({
    Connectivity? connectivity,
    this.urlLookup = 'https://www.example.com',
  }) : super(const InternetState()) {
    this.connectivity = connectivity ?? Connectivity();
    _checkInternetConnection();
  }

  ///  Connectivity package
  late final Connectivity connectivity;

  ///  Connectivity StreamSubscription
  late final StreamSubscription connectivitySubscription;

  ///URL lookup for internet
  final String? urlLookup;

  void _checkInternetConnection() {
    emit(state.copyWith(cubitStatus: CubitStatus.busy));
    if (kIsWeb) {
      emit(
        state.copyWith(
          cubitStatus: CubitStatus.none,
          internetStatus: InternetStatus.connected,
        ),
      );
    } else {
      _subscribeConnectivityChanges();
    }
  }

  void _subscribeConnectivityChanges() {
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((connectivityEvent) {
      switch (connectivityEvent) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
        case ConnectivityResult.bluetooth:
        case ConnectivityResult.ethernet:
          _checkInternet();
          break;
        case ConnectivityResult.none:
          _emitNoInternet();
          break;
      }
    });
  }

  ///Dispose subscriptions
  void dispose() {
    connectivitySubscription.cancel();
  }

  Future<void> _checkInternet() async {
    try {
      final _result = await _lookupAddress();
      final _isOnline = _checkOnlineStatus(_result);
      if (_isOnline) {
        emit(
          state.copyWith(
            cubitStatus: CubitStatus.none,
            internetStatus: InternetStatus.connected,
          ),
        );
      } else {
        _emitNoInternet();
      }
    } catch (e) {
      _emitNoInternet();
    }
  }

  Future<List<InternetAddress>> _lookupAddress() async =>
      InternetAddress.lookup(
        urlLookup ?? 'https://www.example.com',
      );

  bool _checkOnlineStatus(List<InternetAddress> addressList) =>
      addressList.isNotEmpty && addressList.first.rawAddress.isNotEmpty;

  void _emitNoInternet() {
    emit(
      state.copyWith(
        cubitStatus: CubitStatus.none,
        internetStatus: InternetStatus.disconnected,
      ),
    );
  }
}
