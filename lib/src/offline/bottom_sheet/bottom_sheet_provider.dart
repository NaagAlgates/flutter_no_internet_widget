import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/src/offline/offline_widget_type.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// If the FullScreen selected, please enter all the values for this class
class BottomSheetWidget extends OfflineWidgetType implements IWidgetAction {
  ///Fullscreen Widget Constructor
  BottomSheetWidget(
    this.context, {
    this.child,
    this.height,
    this.backgroundColor,
  });

  ///Provide a full screen widget
  final Widget? child;

  ///Bottom Sheet's height
  final double? height;

  ///Provide the current Context
  final BuildContext context;

  ///Provide the current Context
  final Color? backgroundColor;

  @override

  ///Hide Default BottomSheet widget
  void hide(BuildContext context) {
    Navigator.pop(context);
  }

  @override

  ///Display Default BottomSheet widget
  Future<void> display(BuildContext context) async {
    await showModalBottomSheet<Widget>(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 10.0.h,
      enableDrag: false,
      backgroundColor: backgroundColor ?? Colors.white,
      context: context,
      builder: (builder) {
        return Container(
          height: height ?? 90.0.h,
          color: Colors.transparent,
          child: child ??
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0.h),
                    topRight: Radius.circular(10.0.h),
                  ),
                ),
                child: const Center(
                  child: Text('This is a modal sheet'),
                ),
              ),
        );
      },
    );
  }
}
