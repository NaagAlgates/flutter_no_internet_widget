import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_no_internet_widget/src/_cubit/internet_cubit.dart';
import 'package:flutter_no_internet_widget/src/enum/offline_widget_types.dart';
import 'package:flutter_no_internet_widget/src/snackbar/snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///FlutterNoInternetWidget
class InternetWidget extends StatelessWidget {
  /// Use InternetWidget to  show online or offline widgets
  ///
  /// ```dart
  /// InternetWidget(
  ///   key: ValueKey('internet-widget'),
  ///   loadingWidget: Center(
  ///     child: CircularProgressIndicator(),
  ///   ),
  ///   lookupUrl: 'example.com',
  ///   offline: const Text(
  ///     'Offline',
  ///   ),
  ///   online: const Text(
  ///     'Online',
  ///   ),
  /// ),
  /// ```
  /// In case you want to use the default settings,
  /// just provide the online widget
  /// ```dart
  /// InternetWidget(
  ///  online: Container(),
  /// ),
  /// ```
  InternetWidget({
    Key? key,
    this.height,
    this.width,
    this.offline,
    required this.online,
    this.lookupUrl,
    this.loadingWidget,
    this.whenOffline,
    this.whenOnline,
    this.connectivity,
    this.offlineWidgetType = OfflineWidgetType.none,
    this.snackbarProvider,
  }) : super(key: key) {
    _snackbarProvider = snackbarProvider ?? SnackbarProvider();
  }

  ///Width of the widget
  final double? width;

  ///Height of the widget
  final double? height;

  ///Widget to be displayed when there is no internet connection
  final Widget? offline;

  ///Widget to be displayed when there is internet connection
  final Widget? online;

  ///This widget will be displayed when the
  ///cubit is busy checking the internet status
  final Widget? loadingWidget;

  ///A callback method when there is internet connection.
  final VoidCallback? whenOnline;

  ///A callback method when there is no internet connection.
  final VoidCallback? whenOffline;

  ///Lookup Url
  final String? lookupUrl;

  ///Provide your own Connectivity Object
  final Connectivity? connectivity;

  ///Widget type that is displayed when there is no internet
  final OfflineWidgetType offlineWidgetType;

  ///Show Custom Snackbar
  final SnackbarProvider? snackbarProvider;

  late final SnackbarProvider? _snackbarProvider;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(
              connectivity: connectivity,
              urlLookup: lookupUrl,
            ),
            child: Scaffold(
              key: _scaffoldKey,
              body: Builder(
                builder: (_) {
                  return BlocBuilder<InternetCubit, InternetState>(
                    builder: (_, state) {
                      if (state.cubitStatus == CubitStatus.busy) {
                        if (loadingWidget != null) {
                          return loadingWidget!;
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SizedBox(
                        width: width ?? 100.0.w,
                        height: height ?? 100.0.h,
                        child: state.internetStatus == InternetStatus.connected
                            ? _getOnlineWidget(context)
                            : _getOfflineWidget(context),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getOnlineWidget(BuildContext context) {
    if (offlineWidgetType == OfflineWidgetType.snackbar) {
      _snackbarProvider?.hideSnackbar(context);
    }
    if (online == null) {
      return const Center(
        key: ValueKey('default-online-widget'),
        child: Text('Online'),
      );
    }
    whenOnline?.call();
    return online!;
  }

  Widget? _getOfflineWidget(BuildContext context) {
    whenOffline?.call();
    if (offlineWidgetType == OfflineWidgetType.snackbar) {
      _showSnackbarWidget(context);
      return _displayOfflineWidget(context);
    } else if (offlineWidgetType == OfflineWidgetType.fullscreen) {
      return _displayOfflineWidget(context);
    } else {
      if (offline == null) {
        return _displayDefaultOfflineWidget();
      } else {
        return _displayCustomOfflineWidget();
      }
    }
  }

  void _showSnackbarWidget(BuildContext context) =>
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _snackbarProvider?.displaySnackbar(context),
      );

  Widget _displayDefaultOfflineWidget() => const Center(
        key: ValueKey('default-offline-widget'),
        child: Text('Offline'),
      );

  Widget _displayCustomOfflineWidget() => offline!;

  Widget _displayOfflineWidget(BuildContext context) {
    if (offline == null) {
      if (offlineWidgetType == OfflineWidgetType.snackbar) {
        return _onlineWidget();
      } else if (offlineWidgetType == OfflineWidgetType.fullscreen) {
        return _displayDefaultOfflineWidget();
      } else {
        return Container();
      }
    } else {
      return _displayCustomOfflineWidget();
    }
  }

  Widget _onlineWidget() => online!;
}
