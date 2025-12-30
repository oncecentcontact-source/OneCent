import 'package:hive/hive.dart';

part 'couple.g.dart';

@HiveType(typeId: 0)
class CoupleProfile extends HiveObject {
  @HiveField(0)
  String nameA;

  @HiveField(1)
  String nameB;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  String? avatarAPath;

  @HiveField(4)
  String? avatarBPath;

  CoupleProfile({
    required this.nameA,
    required this.nameB,
    required this.startDate,
    this.avatarAPath,
    this.avatarBPath,
  });

  // Calculate days together
  int get daysTogether {
    final now = DateTime.now();
    return now.difference(startDate).inDays;
  }

  // Get next anniversary
  DateTime get nextAnniversary {
    final now = DateTime.now();
    var nextDate = DateTime(now.year, startDate.month, startDate.day);
    
    if (nextDate.isBefore(now)) {
      nextDate = DateTime(now.year + 1, startDate.month, startDate.day);
    }
    
    return nextDate;
  }

  // Days until next anniversary
  int get daysUntilAnniversary {
    final now = DateTime.now();
    return nextAnniversary.difference(now).inDays;
  }

  // Get detailed duration (Years, Months, Days)
  Map<String, int> get durationDetail {
    final now = DateTime.now();
    int years = now.year - startDate.year;
    int months = now.month - startDate.month;
    int days = now.day - startDate.day;

    if (days < 0) {
      months--;
      final daysInLastMonth = DateTime(now.year, now.month, 0).day;
      days += daysInLastMonth;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }
}
