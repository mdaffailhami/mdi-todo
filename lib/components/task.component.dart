import 'package:flutter/material.dart';

class TaskComponent extends StatelessWidget {
  final String title;
  final void Function()? onChecked;

  const TaskComponent({
    Key? key,
    this.title = '',
    this.onChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: CardCheckBox(
          onChecked: onChecked,
        ),
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

class CardCheckBox extends StatefulWidget {
  final void Function()? onChecked;

  const CardCheckBox({Key? key, this.onChecked}) : super(key: key);

  @override
  _CardCheckBoxState createState() => _CardCheckBoxState();
}

class _CardCheckBoxState extends State<CardCheckBox> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (bool? value) {
        widget.onChecked!();

        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
