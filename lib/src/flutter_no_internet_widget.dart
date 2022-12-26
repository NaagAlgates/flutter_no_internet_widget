import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    this.offline,
    required this.online,
    this.lookupUrl,
    this.loadingWidget,
    this.whenOffline,
    this.whenOnline,
    this.connectivity,
  }) : super(key: key);

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
                      return SizedBox(
                        width: width ?? 100.0.w,
                        height: height ?? 100.0.h,
                        child: state.internetStatus == InternetStatus.connected
                            ? _getOnlineWidget()
                            : _getOfflineWidget(),
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

  Widget _getOnlineWidget() {
    if (online == null) {
      return const Center(
        key: ValueKey('default-online-widget'),
        child: Text('Online'),
      );
    }
    whenOnline?.call();
    return online!;
  }

  Widget _getOfflineWidget() {
    if (offline == null) {
      return const Center(
        key: ValueKey('default-offline-widget'),
        child: Text('Offline'),
      );
    }
    whenOffline?.call();
    return offline!;
  }
}
