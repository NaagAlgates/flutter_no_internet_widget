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

  /// When internet is connected
  connected,

  /// When internet is disconnected
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
    this.urlLookup = 'github.com',
  }) : super(const InternetState()) {
    this.connectivity = connectivity ?? Connectivity();
    _init();
  }

  void _init() {
    _checkInternetConnection();
    _checkInternet();
  }

  ///  Connectivity package
  late final Connectivity connectivity;

  ///  Connectivity StreamSubscription
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;

  ///URL lookup for internet
  final String? urlLookup;

  void _checkInternetConnection() {
    emit(state.copyWith(cubitStatus: CubitStatus.busy));
    if (kIsWeb) {
      _emitConnected();
    }
    _subscribeConnectivityChanges();
  }

  void _emitConnected() {
    emit(
      state.copyWith(
        cubitStatus: CubitStatus.none,
        internetStatus: InternetStatus.connected,
      ),
    );
  }

  void _subscribeConnectivityChanges() {
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((connectivityEvent) {
      if (connectivityEvent == ConnectivityResult.none) {
        _emitNoInternet();
      } else {
        _checkInternet();
      }
    });
  }

  ///Dispose subscriptions
  void dispose() {
    connectivitySubscription.cancel();
  }

  Future<void> _checkInternet() async {
    try {
      if (kIsWeb) {
        _emitConnected();
        return;
      }
      final result = await _lookupAddress();
      final isOnline = _checkOnlineStatus(result);
      if (isOnline) {
        _emitConnected();
      } else {
        _emitNoInternet();
      }
    } catch (e) {
      _emitNoInternet();
    }
  }

  Future<List<InternetAddress>> _lookupAddress() async {
    final lookupUrl = urlLookup ?? 'github.com';
    final internetAddress = await InternetAddress.lookup(
      lookupUrl,
    );
    return internetAddress;
  }

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
