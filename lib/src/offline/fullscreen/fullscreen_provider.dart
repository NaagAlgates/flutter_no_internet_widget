import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/src/offline/offline_widget_type.dart';

/// If the FullScreen selected, please enter all the values for this class
class FullScreenWidget extends OfflineWidgetType {
  ///Fullscreen Widget Constructor
  const FullScreenWidget({
    this.child,
  }) : super();

  ///Provide a full screen widget
  final Widget? child;
}
