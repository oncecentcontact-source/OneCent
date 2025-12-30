import 'package:hive/hive.dart';
import 'package:single/data/models/checkin.dart';

class CheckInStorage {
  static const String _boxName = 'checkins';

  // Get the box
  static Box<CheckIn> get _box => Hive.box<CheckIn>(_boxName);

  // Initialize the box
  static Future<void> init() async {
    await Hive.openBox<CheckIn>(_boxName);
  }

  // Add check-in
  static Future<void> addCheckIn(CheckIn checkIn) async {
    await _box.put(checkIn.id, checkIn);
  }

  // Get all check-ins
  static List<CheckIn> getAllCheckIns() {
    return _box.values.toList();
  }

  // Get check-in by ID
  static CheckIn? getCheckIn(String id) {
    return _box.get(id);
  }

  // Get check-in for today
  static CheckIn? getTodayCheckIn() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    
    for (var checkIn in _box.values) {
      final checkInKey = '${checkIn.date.year}-${checkIn.date.month}-${checkIn.date.day}';
      if (checkInKey == todayKey) {
        return checkIn;
      }
    }
    return null;
  }

  // Update check-in
  static Future<void> updateCheckIn(CheckIn checkIn) async {
    await _box.put(checkIn.id, checkIn);
  }

  // Delete check-in
  static Future<void> deleteCheckIn(String id) async {
    await _box.delete(id);
  }

  // Get check-ins sorted by date (newest first)
  static List<CheckIn> getCheckInsSorted() {
    final checkIns = getAllCheckIns();
    checkIns.sort((a, b) => b.date.compareTo(a.date));
    return checkIns;
  }

  // Get check-ins count
  static int getCheckInsCount() {
    return _box.length;
  }

  // Clear all check-ins
  static Future<void> clearAll() async {
    await _box.clear();
  }

  // Close box
  static Future<void> close() async {
    await _box.close();
  }
}
