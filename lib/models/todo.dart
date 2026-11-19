import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0) // Sesuaikan typeId Anda jika berbeda
class Todo extends HiveObject {
  @HiveField(0)
  final String spell;

  @HiveField(1)
  final String use;

  @HiveField(2)
  final int index;

  Todo({
    required this.spell,
    required this.use,
    required this.index,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      spell: json['spell'] ?? '',
      use: json['use'] ?? '',
      index: json['index'] ?? 0,
    );
  }
}