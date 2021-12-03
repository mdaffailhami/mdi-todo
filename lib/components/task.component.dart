import 'package:flutter/material.dart';

class TaskComponent extends StatelessWidget {
  final String title;
  final void Function()? onCheck;
  final void Function()? onTap;

  const TaskComponent({
    Key? key,
    this.title = '',
    this.onCheck,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: CardCheckBox(
          onCheck: onCheck,
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

class CardCheckBox extends StatefulWidget {
  final void Function()? onCheck;

  const CardCheckBox({Key? key, this.onCheck}) : super(key: key);

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
        widget.onCheck!();

        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
