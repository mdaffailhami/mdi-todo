import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String label,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(label),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
        textColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
    ),
  );
}
