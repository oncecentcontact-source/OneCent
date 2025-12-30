import 'package:hive/hive.dart';

part 'memory.g.dart';

@HiveType(typeId: 1)
class Memory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? note;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? photoPath;

  Memory({
    required this.id,
    required this.title,
    this.note,
    required this.date,
    this.photoPath,
  });

  // Create a copy with updated fields
  Memory copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? date,
    String? photoPath,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
