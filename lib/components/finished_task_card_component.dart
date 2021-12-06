import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'finished_task_preview_component.dart';

class FinishedTaskCardComponent extends StatefulWidget {
  final String id;
  final String title;
  final String date;

  const FinishedTaskCardComponent({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  State<FinishedTaskCardComponent> createState() =>
      _FinishedTaskCardComponentState();
}

class _FinishedTaskCardComponentState extends State<FinishedTaskCardComponent> {
  bool? isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = true;
  }

  void onTaskTapped() {
    showDialog(
      context: context,
      builder: (_) {
        return FinishedTaskPreviewComponent(
          id: widget.id,
          title: widget.title,
          date: widget.date,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          shape: const CircleBorder(),
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        ),
        title: Text(widget.title),
        subtitle: Text(DateFormat.yMMMMd().format(DateTime.parse(widget.date))),
        onTap: onTaskTapped,
      ),
    );
  }
}
