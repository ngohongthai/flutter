import 'package:equatable/equatable.dart';
import 'package:todos_repository/src/entities/entities.dart';
import 'package:uuid/uuid.dart';

class Todo extends Equatable {
  final String id;
  final String note;
  final String task;
  final bool complete;

  Todo({required this.task,
    this.complete = false,
    String? id,
    String? note = ''})
      : this.note = note ?? '',
        this.id = id ?? Uuid().v4();

  Todo copyWith({bool? complete, String? task, String? note}) {
    return Todo(
        id: id,
        task: task ?? this.task,
        note: note ?? this.note,
        complete: complete ?? this.complete);
  }

  @override
  List<Object> get props => [id, note, task, complete];

  @override
  String toString() {
    return 'Todo{id: $id, note: $note, task: $task, complete: $complete}';
  }

  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      task: task,
      complete: complete,
      note: note,
    );
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      id: entity.id,
      task: entity.task,
      complete: entity.complete,
      note: entity.note,
    );
  }
}
