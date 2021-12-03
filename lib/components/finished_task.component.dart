import 'package:flutter/material.dart';

class FinishedTaskComponent extends StatelessWidget {
  final String title;
  final void Function()? onUnchecked;

  const FinishedTaskComponent({
    Key? key,
    this.title = '',
    this.onUnchecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: CardCheckBox(
          onUnchecked: onUnchecked,
        ),
        title: Text(title),
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
      onChanged: (bool? value) {
        widget.onUnchecked!();

        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
