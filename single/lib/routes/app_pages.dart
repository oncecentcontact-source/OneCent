import 'package:get/get.dart';
import 'package:single/modules/onboarding/onboarding_page.dart';
import 'package:single/modules/home/home_page.dart';
import 'package:single/modules/memories/memories_list_page.dart';
import 'package:single/modules/memories/add_memory_page.dart';
import 'package:single/modules/memories/memory_detail_page.dart';
import 'package:single/modules/checkin/checkin_page.dart';
import 'package:single/modules/checkin/checkin_history_page.dart';
import 'package:single/modules/settings/settings_page.dart';

class AppPages {
  static const initial = '/';
  static const home = '/home';
  static const memories = '/memories';
  static const addMemory = '/add-memory';
  static const memoryDetail = '/memory-detail';
  static const checkIn = '/checkin';
  static const checkInHistory = '/checkin-history';
  static const settings = '/settings';

  static final routes = [
    GetPage(
      name: initial,
      page: () => const OnboardingPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: memories,
      page: () => const MemoriesListPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addMemory,
      page: () => const AddMemoryPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: memoryDetail,
      page: () => const MemoryDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: checkIn,
      page: () => const CheckInPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: checkInHistory,
      page: () => const CheckInHistoryPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
