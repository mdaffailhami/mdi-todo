import 'package:flutter/material.dart';

class DeleteTaskConfirmation extends StatelessWidget {
  final void Function()? onYesButtonPressed;
  final void Function()? onNoButtonPressed;
  const DeleteTaskConfirmation({
    Key? key,
    this.onYesButtonPressed,
    this.onNoButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Are you sure you want to delete this task?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: onYesButtonPressed,
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: onNoButtonPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red[400])),
          child: const Text('No'),
        ),
      ],
    );
  }
}
