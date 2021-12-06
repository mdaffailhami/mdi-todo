import 'package:flutter/material.dart';

class TaskComponent extends StatelessWidget {
  final String title;
  const TaskComponent(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: const Icon(Icons.access_alarm),
        title: Text(title),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
          tooltip: 'Options',
        ),
      ),
    );
  }
}
