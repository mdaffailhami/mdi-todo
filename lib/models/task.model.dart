class TaskModel {
  final String id;
  final String title;
  final String date;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }
}
