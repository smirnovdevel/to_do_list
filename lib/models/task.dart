import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TaskModel extends Equatable {
  int? id;
  String title;
  bool active;
  int priority;
  bool unlimited;
  DateTime deadline;

  TaskModel(
      {this.id,
      required this.title,
      required this.active,
      required this.priority,
      required this.unlimited,
      required this.deadline});

  @override
  List<Object?> get props => [id, title, active, priority, unlimited, deadline];

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['active'] = active ? 1 : 0;
    map['priority'] = priority;
    map['unlimited'] = unlimited ? 1 : 0;
    map['deadline'] = deadline.toString();
    return map;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      active: (map['active'] == 1) ? true : false,
      priority: map['priority'],
      unlimited: (map['unlimited'] == 1) ? true : false,
      deadline: DateTime.tryParse(map['deadline']) ?? DateTime.now(),
    );
  }
}
