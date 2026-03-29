import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  required String defaultActionText,
  bool isDestructive = false,
}) async {
  return showAdaptiveDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: [
        if (cancelActionText != null)
          _adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        _adaptiveAction(
          context: context,
          isDefaultAction: true,
          isDestructiveAction: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

Widget _adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool isDefaultAction = false,
  bool isDestructiveAction = false,
}) =>
    switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => CupertinoDialogAction(
          isDefaultAction: isDefaultAction,
          isDestructiveAction: isDestructiveAction,
          onPressed: onPressed,
          child: child,
        ),
      _ => TextButton(onPressed: onPressed, child: child),
    };
