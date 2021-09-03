import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final bool complete;
  final String task;
  final String? note;

  const TodoEntity(
      {required this.id,
      required this.complete,
      required this.task,
      this.note});

  Map<String, Object?> toJson() {
    return {
      "id": this.id,
      "complete": this.complete,
      "task": this.task,
      "note": this.note,
    };
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      id: json["id"] as String,
      complete: json["complete"] as bool,
      task: json["task"] as String,
      note: json["note"] as String?,
    );
  }

  static TodoEntity fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    if (data == null) throw Exception();
    return TodoEntity(
      id: data['id'],
      task: data['task'],
      complete: data['complete'],
      note: data['note'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'complete': complete,
      'task': task,
      'note': note,
    };
  }

  @override
  List<Object?> get props => [id, complete, task, note];

  @override
  String toString() {
    return 'TodoEntity{id: $id, complete: $complete, task: $task, note: $note}';
  }

//

}
