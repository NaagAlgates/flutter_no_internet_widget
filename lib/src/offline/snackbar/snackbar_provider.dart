import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/src/offline/offline_widget_type.dart';
import 'package:flutter_no_internet_widget/src/offline/snackbar/snackbar_position.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// If the Snackbar enum is selected, please enter all the values for this class
class SnackbarWidget extends OfflineWidgetType implements IWidgetAction {
  ///Snackbar constructor
  const SnackbarWidget({
    this.snackbar,
    this.snackbarPosition,
  }) : super();

  ///Provide custom Snackbar
  final SnackBar? snackbar;

  ///Provide the position of the Snackbar if the default snackbar is consumed
  final SnackbarPosition? snackbarPosition;

  @override

  ///Hide Default Snackbar widget
  void hide(BuildContext context) =>
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

  @override

  ///Display Default Snackbar widget
  void display(BuildContext context) {
    final localSnackbar = snackbar ?? _defaultSnackbar();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(localSnackbar);
  }

  SnackBar _defaultSnackbar() => SnackBar(
        key: const ValueKey('default-snackbar'),
        dismissDirection: DismissDirection.none,
        backgroundColor: Colors.red,
        behavior: (snackbarPosition ?? SnackbarPosition.bottom) ==
                SnackbarPosition.top
            ? SnackBarBehavior.floating
            : null,
        margin: (snackbarPosition ?? SnackbarPosition.bottom) ==
                SnackbarPosition.top
            ? EdgeInsets.only(
                bottom: 85.0.h,
              )
            : null,
        elevation: (snackbarPosition ?? SnackbarPosition.bottom) ==
                SnackbarPosition.top
            ? 10
            : 1,
        content: const Text(
          'Offline',
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(
          days: 10,
        ),
      );
}

/// Display the default snackbar at top
class TopSnackBar extends SnackbarWidget {
  ///Constructor for displaying the default snackbar at top
  const TopSnackBar([SnackBar? snackbar])
      : super(
          snackbarPosition: SnackbarPosition.top,
          snackbar: snackbar,
        );
}

/// Display the default snackbar at bottom
class BottomSnackBar extends SnackbarWidget {
  ///Constructor for displaying the default snackbar at bottom
  const BottomSnackBar([SnackBar? snackbar])
      : super(
          snackbarPosition: SnackbarPosition.bottom,
          snackbar: snackbar,
        );
}
