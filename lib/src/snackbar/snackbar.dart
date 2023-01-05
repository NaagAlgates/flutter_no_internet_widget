import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/src/snackbar/snackbar_position.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// SnackBar Interface
abstract class ISnackbar {
  ///Display Default Snackbar widget
  void displaySnackbar(BuildContext context);

  ///Hide Default Snackbar widget
  void hideSnackbar(BuildContext context);
}

@protected

/// If the Snackbar enum is selected, please enter all the values for this class
class SnackbarProvider extends ISnackbar {
  ///Snackbar constructor
  SnackbarProvider({
    this.snackbar,
    this.snackbarPosition = SnackbarPosition.bottom,
  });

  ///Provide custom Snackbar
  final SnackBar? snackbar;

  ///Provide the position of the Snackbar if the default snackbar is consumed
  final SnackbarPosition? snackbarPosition;
  @override

  ///Hide Default Snackbar widget
  void hideSnackbar(BuildContext context) =>
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

  @override

  ///Display Default Snackbar widget
  void displaySnackbar(BuildContext context) {
    final _snackBar = snackbar ?? _defaultSnackbar();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_snackBar);
  }

  SnackBar _defaultSnackbar() => SnackBar(
        backgroundColor: Colors.red,
        behavior: snackbarPosition == SnackbarPosition.top
            ? SnackBarBehavior.floating
            : SnackBarBehavior.fixed,
        margin: snackbarPosition == SnackbarPosition.top
            ? EdgeInsets.only(
                bottom: 85.0.h,
              )
            : null,
        elevation: 10,
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
class TopSnackBar extends SnackbarProvider {
  ///Constructor for displaying the default snackbar at top
  TopSnackBar([SnackBar? snackbar])
      : super(
          snackbarPosition: SnackbarPosition.top,
          snackbar: snackbar,
        );
}

/// Display the default snackbar at bottom
class BottomSnackBar extends SnackbarProvider {
  ///Constructor for displaying the default snackbar at bottom
  BottomSnackBar([SnackBar? snackbar])
      : super(
          snackbarPosition: SnackbarPosition.bottom,
          snackbar: snackbar,
        );
}
