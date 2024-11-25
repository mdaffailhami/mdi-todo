// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  final String id;
  final String title;
  final DateTime deadline;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    required this.deadline,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? deadline,
    // Use function in order to be able to set a value to null
    DateTime? Function()? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      completedAt: completedAt == null ? null : completedAt(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'deadline': deadline.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, deadline: $deadline, completedAt: $completedAt)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.deadline == deadline &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        deadline.hashCode ^
        completedAt.hashCode;
  }
}
