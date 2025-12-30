import 'package:hive/hive.dart';

part 'checkin.g.dart';

@HiveType(typeId: 2)
class CheckIn extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int mood; // 1-5 rating

  @HiveField(3)
  String? note;

  CheckIn({
    required this.id,
    required this.date,
    required this.mood,
    this.note,
  });

  // Get mood emoji
  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😍';
      default:
        return '😐';
    }
  }

  // Get mood label
  String get moodLabel {
    switch (mood) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Okay';
      case 4:
        return 'Happy';
      case 5:
        return 'Very Happy';
      default:
        return 'Okay';
    }
  }
}
