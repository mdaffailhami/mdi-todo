import 'package:flutter/material.dart';

class DeleteTaskConfirmationComponent extends StatelessWidget {
  const DeleteTaskConfirmationComponent({Key? key}) : super(key: key);

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
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text(
            'YES',
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('NO'),
        ),
      ],
    );
  }
}
