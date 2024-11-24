// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Completion {
  bool isCompleted;
  DateTime completedAt;

  Completion({
    required this.isCompleted,
    required this.completedAt,
  });

  Completion copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Completion(
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isCompleted': isCompleted,
      'completedAt': completedAt.millisecondsSinceEpoch,
    };
  }

  factory Completion.fromMap(Map<String, dynamic> map) {
    return Completion(
      isCompleted: map['isCompleted'] as bool,
      completedAt:
          DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Completion.fromJson(String source) =>
      Completion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Completion(isCompleted: $isCompleted, completedAt: $completedAt)';

  @override
  bool operator ==(covariant Completion other) {
    if (identical(this, other)) return true;

    return other.isCompleted == isCompleted && other.completedAt == completedAt;
  }

  @override
  int get hashCode => isCompleted.hashCode ^ completedAt.hashCode;
}
