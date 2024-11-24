// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mdi_todo/data/models/completion.dart';

class Task {
  String id;
  String title;
  DateTime deadline;
  Completion completion;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.completion,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? deadline,
    Completion? completion,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      completion: completion ?? this.completion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'deadline': deadline.millisecondsSinceEpoch,
      'completion': completion.toMap(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int),
      completion: Completion.fromMap(map['completion'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, deadline: $deadline, completion: $completion)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.deadline == deadline &&
        other.completion == completion;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        deadline.hashCode ^
        completion.hashCode;
  }
}
