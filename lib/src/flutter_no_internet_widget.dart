import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:flutter_no_internet_widget/src/_cubit/internet_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  const InternetWidget({
    Key? key,
    this.height,
    this.width,
    required this.online,
    this.lookupUrl,
    this.loadingWidget,
    this.whenOffline,
    this.whenOnline,
    this.connectivity,
    this.offline,
  }) : super(key: key);

  ///Width of the widget
  final double? width;

  ///Height of the widget
  final double? height;

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

  ///Widget to be displayed when there is no internet connection
  final OfflineWidgetType? offline;

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
                      return Stack(
                        children: [
                          _getOnlineWidget(context),
                          _getOfflineWidget(context, state.internetStatus),
                        ],
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
    if (offline is SnackbarWidget) {
      (offline as SnackbarWidget?)?.hide(context);
    } else if (offline is BottomSheetWidget) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => (offline as BottomSheetWidget?)?.hide(context),
      );
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

  Widget _getOfflineWidget(BuildContext context, InternetStatus status) {
    if (status == InternetStatus.connected) return Container();
    whenOffline?.call();
    if (offline is SnackbarWidget) {
      _showSnackbarWidget(context);
      return _onlineWidget();
    } else if (offline is FullScreenWidget) {
      if ((offline as FullScreenWidget?)?.child != null) {
        return (offline as FullScreenWidget?)?.child ?? Container();
      }
      return _displayDefaultOfflineWidget();
    } else if (offline is BottomSheetWidget) {
      if ((offline as BottomSheetWidget?)?.child != null) {
        return (offline as BottomSheetWidget?)?.child ?? Container();
      }
      _showBottomSheetWidget(context);
      return _onlineWidget();
    } else {
      return _onlineWidget();
    }
  }

  void _showSnackbarWidget(BuildContext context) {
    if (offline is SnackbarWidget) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => (offline as SnackbarWidget?)?.display(context),
      );
    }
  }

  void _showBottomSheetWidget(BuildContext context) {
    if (offline is BottomSheetWidget) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => (offline as BottomSheetWidget?)?.display(context),
      );
    }
  }

  Widget _displayDefaultOfflineWidget() => Container(
        color: Colors.white,
        height: 100.0.h,
        width: 100.0.w,
        child: const Center(
          key: ValueKey('default-offline-widget'),
          child: Text('Offline'),
        ),
      );

  Widget _onlineWidget() => online!;
}
