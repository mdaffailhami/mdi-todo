import 'package:flutter/material.dart';

class FinishedTasksTab extends StatelessWidget {
  const FinishedTasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No tasks finished!',
        style:
            Theme.of(context).textTheme.headline6?.copyWith(color: Colors.grey),
      ),
    );
  }
}
