import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinishedTaskComponent extends StatelessWidget {
  final String title;
  final String date;
  final void Function()? onUnchecked;

  const FinishedTaskComponent({
    Key? key,
    required this.title,
    required this.date,
    this.onUnchecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('MMMM dd, yyyy').format(DateTime.parse(date)).toString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: CardCheckBox(
          onUnchecked: onUnchecked,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          formattedDate,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

class CardCheckBox extends StatefulWidget {
  final void Function()? onUnchecked;

  const CardCheckBox({Key? key, this.onUnchecked}) : super(key: key);

  @override
  _CardCheckBoxState createState() => _CardCheckBoxState();
}

class _CardCheckBoxState extends State<CardCheckBox> {
  bool? isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      shape: const CircleBorder(),
      onChanged: (bool? value) {
        widget.onUnchecked!();

        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
