import 'package:flutter/material.dart';

///Base class for the Offline Widget Type
class OfflineWidgetType {
  ///Offline Widget Constructor
  const OfflineWidgetType();
}

/// Widget Interface
abstract class IWidgetAction {
  ///Display Default Snackbar widget
  void display(BuildContext context);

  ///Hide Default Snackbar widget
  void hide(BuildContext context);
}
