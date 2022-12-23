class Task {
  String id;
  String name;
  DateTime deadline;
  bool completed;
  DateTime? completionDateTime;

  Task({
    required this.id,
    required this.name,
    required this.deadline,
    required this.completed,
    this.completionDateTime,
  });

  factory Task.from(Task task) {
    return Task(
      id: task.id,
      name: task.name,
      deadline: task.deadline,
      completed: task.completed,
      completionDateTime: task.completionDateTime,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      name: map['name'] as String,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int),
      completed: map['completed'] as bool,
      completionDateTime: map['completionDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['completionDateTime'] as int)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'deadline': deadline.millisecondsSinceEpoch,
      'completed': completed,
      'completionDateTime': completionDateTime?.millisecondsSinceEpoch,
    };
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.deadline == deadline &&
        other.completed == completed &&
        other.completionDateTime == completionDateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        deadline.hashCode ^
        completed.hashCode ^
        completionDateTime.hashCode;
  }
}
