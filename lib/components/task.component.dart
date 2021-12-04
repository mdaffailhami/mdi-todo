import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskComponent extends StatelessWidget {
  final String title;
  final String date;
  final void Function()? onChecked;
  final void Function()? onTap;

  const TaskComponent({
    Key? key,
    required this.title,
    required this.date,
    this.onChecked,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('MMMM dd, yyyy').format(DateTime.parse(date)).toString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: CardCheckBox(
          onChecked: onChecked,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          formattedDate,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onTap: onTap,
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
      shape: const CircleBorder(),
      onChanged: (bool? value) {
        widget.onChecked!();

        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
