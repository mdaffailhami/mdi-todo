import 'package:flutter/material.dart';

class AddTaskFormComponent extends StatelessWidget {
  const AddTaskFormComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter task here..'),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('17 October, 2003'),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 50),
                    lastDate: DateTime(DateTime.now().year + 50),
                  );
                },
                child: Icon(Icons.date_range),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('ADD'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('CANCEL'),
        ),
      ],
    );
  }
}
