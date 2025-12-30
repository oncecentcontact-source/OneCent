import 'package:get/get.dart';
import 'package:single/data/models/checkin.dart';
import 'package:single/data/storage/checkin_storage.dart';

class CheckInController extends GetxController {
  final RxList<CheckIn> checkIns = <CheckIn>[].obs;
  final Rx<CheckIn?> todayCheckIn = Rx<CheckIn?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCheckIns();
    loadTodayCheckIn();
  }

  // Load all check-ins
  void loadCheckIns() {
    checkIns.value = CheckInStorage.getCheckInsSorted();
  }

  // Load today's check-in
  void loadTodayCheckIn() {
    todayCheckIn.value = CheckInStorage.getTodayCheckIn();
  }

  // Add or update check-in
  Future<void> saveCheckIn(CheckIn checkIn) async {
    await CheckInStorage.addCheckIn(checkIn);
    loadCheckIns();
    loadTodayCheckIn();
  }

  // Delete check-in
  Future<void> deleteCheckIn(String id) async {
    await CheckInStorage.deleteCheckIn(id);
    loadCheckIns();
    loadTodayCheckIn();
  }

  // Check if checked in today
  bool get hasCheckedInToday => todayCheckIn.value != null;

  // Get check-ins count
  int get checkInsCount => checkIns.length;

  // Get average mood (last 7 days)
  double get averageMood {
    if (checkIns.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    final recentCheckIns = checkIns.where((checkIn) {
      return checkIn.date.isAfter(sevenDaysAgo);
    }).toList();
    
    if (recentCheckIns.isEmpty) return 0.0;
    
    final sum = recentCheckIns.fold<int>(0, (sum, checkIn) => sum + checkIn.mood);
    return sum / recentCheckIns.length;
  }
}
