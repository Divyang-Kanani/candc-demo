import 'package:candc_demo_flutter/main.dart';
import 'package:flutter/material.dart';

class CustomProgressDialog {
  /// Show a simple loading dialog with a medium circular progress bar
  static void show() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user can’t tap outside to close
      builder: (context) {
        return Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
          ),
        );
      },
    );
  }

  /// Hide the dialog
  static void dismiss() {
    Navigator.of(navigatorKey.currentContext!).pop();
  }
}
