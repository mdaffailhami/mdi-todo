class TaskModel {
  final String id;
  final String title;

  TaskModel({required this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
