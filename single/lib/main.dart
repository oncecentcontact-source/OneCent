import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:single/data/models/couple.dart';
import 'package:single/data/models/memory.dart';
import 'package:single/data/models/checkin.dart';
import 'package:single/data/storage/profile_storage.dart';
import 'package:single/data/storage/memory_storage.dart';
import 'package:single/data/storage/checkin_storage.dart';
import 'package:single/controllers/profile_controller.dart';
import 'package:single/controllers/memory_controller.dart';
import 'package:single/controllers/checkin_controller.dart';
import 'package:single/controllers/settings_controller.dart';
import 'package:single/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize Timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('UTC')); // Set default timezone

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(CoupleProfileAdapter());
  Hive.registerAdapter(MemoryAdapter());
  Hive.registerAdapter(CheckInAdapter());
  
  // Open boxes
  await ProfileStorage.init();
  await MemoryStorage.init();
  await CheckInStorage.init();
  
  // Initialize GetX controllers
  Get.put(ProfileController());
  Get.put(MemoryController());
  Get.put(CheckInController());
  Get.put(SettingsController());
  
  runApp(const SingleApp());
}

class SingleApp extends StatelessWidget {
  const SingleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final settingsController = Get.find<SettingsController>();
    
    // Determine initial route based on profile existence
    final initialRoute = profileController.hasProfile() 
        ? AppPages.home 
        : AppPages.initial;
    
    return Obx(() => GetMaterialApp(
      title: 'Ours Days',
      debugShowCheckedModeBanner: false,
      theme: settingsController.currentTheme.value,
      themeMode: ThemeMode.light, // Prevent system dark mode from overriding
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    ));
  }
}
