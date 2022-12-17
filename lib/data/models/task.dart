// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mdi_todo/utils/generate_uid.dart';

class Task {
  final String id;
  final bool completed;
  final String name;
  final DateTime deadline;
  final DateTime? completionDateTime;

  Task({
    String? id,
    this.completed = false,
    required this.name,
    required this.deadline,
    this.completionDateTime,
  }) : id = id ?? generateUid();

  Task copyWith({
    String? id,
    bool? completed,
    String? name,
    DateTime? deadline,
    DateTime? Function()? completionDateTime,
  }) {
    return Task(
      id: id ?? this.id,
      completed: completed ?? this.completed,
      name: name ?? this.name,
      deadline: deadline ?? this.deadline,
      completionDateTime: completionDateTime == null
          ? this.completionDateTime
          : completionDateTime(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'completed': completed,
      'name': name,
      'deadline': deadline.millisecondsSinceEpoch,
      'completionDateTime': completionDateTime?.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      completed: map['completed'] as bool,
      name: map['name'] as String,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int),
      completionDateTime: map['completionDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['completionDateTime'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, completed: $completed, name: $name, deadline: $deadline, completionDateTime: $completionDateTime)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.completed == completed &&
        other.name == name &&
        other.deadline == deadline &&
        other.completionDateTime == completionDateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        completed.hashCode ^
        name.hashCode ^
        deadline.hashCode ^
        completionDateTime.hashCode;
  }
}
