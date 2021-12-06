import 'package:flutter/material.dart';

class TaskCardComponent extends StatelessWidget {
  const TaskCardComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: false,
          onChanged: (bool? value) {},
          shape: CircleBorder(),
        ),
        title: SelectableText('Membuat video tutorial Flutter Todo App'),
        subtitle: SelectableText(
          'Mana saia tau saia kan ikan, bapak kau solo lord pake estes',
        ),
      ),
    );
  }
}
