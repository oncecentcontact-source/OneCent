import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:single/controllers/profile_controller.dart';
import 'package:single/services/notification_service.dart';
import 'package:single/theme/app_theme.dart';

class SettingsController extends GetxController {
  final Rx<ThemeData> currentTheme = AppTheme.blackPinkTheme.obs;
  final RxString themeName = 'Black & Pink'.obs;
  
  // Notification Settings
  final RxBool notifMonthly = false.obs;
  final RxBool notifYearly = false.obs;
  final RxBool notifSpecialDays = false.obs;
  
  final _storage = GetStorage();
  final _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _initNotifications();
  }
  
  Future<void> _initNotifications() async {
    await _notificationService.init();
    await _notificationService.requestPermissions();
  }

  void _loadSettings() {
    notifMonthly.value = _storage.read('notif_monthly') ?? false;
    notifYearly.value = _storage.read('notif_yearly') ?? false;
    notifSpecialDays.value = _storage.read('notif_special_days') ?? false;
  }

  // Change theme
  void changeTheme(String theme) {
    switch (theme) {
      case 'Black & Pink':
        currentTheme.value = AppTheme.blackPinkTheme;
        themeName.value = 'Black & Pink';
        break;
      case 'Light':
        currentTheme.value = AppTheme.lightTheme;
        themeName.value = 'Light';
        break;
      case 'Dark':
        currentTheme.value = AppTheme.darkTheme;
        themeName.value = 'Dark';
        break;
      default:
        currentTheme.value = AppTheme.blackPinkTheme;
        themeName.value = 'Black & Pink';
    }
    Get.changeTheme(currentTheme.value);
  }

  // Notification Toggles
  void toggleMonthly(bool value) {
    notifMonthly.value = value;
    _storage.write('notif_monthly', value);
    _updateSchedule();
  }

  void toggleYearly(bool value) {
    notifYearly.value = value;
    _storage.write('notif_yearly', value);
    _updateSchedule();
  }

  void toggleSpecialDays(bool value) {
    notifSpecialDays.value = value;
    _storage.write('notif_special_days', value);
    _updateSchedule();
  }
  
  // Send test notification
  Future<void> sendTestNotification() async {
    await _notificationService.scheduleTestNotification();
  }
  
  // Update schedules based on current settings
  Future<void> _updateSchedule() async {
    // Ensure we have notification permissions before scheduling
    await _notificationService.requestPermissions();

    final ProfileController profileController = Get.find();
    final profile = profileController.profile.value;
    
    if (profile == null) return;
    
    try {
      // Monthly
      if (notifMonthly.value) {
        await _notificationService.scheduleMonthlyAnniversary(profile.startDate);
      } else {
        await _notificationService.cancelMonthly();
      }
      
      // Yearly (use inexact schedule to avoid exact alarm permission)
      if (notifYearly.value) {
        await _notificationService.scheduleYearlyAnniversary(profile.startDate);
      } else {
        await _notificationService.cancelYearly();
      }
      
      // Milestones
      if (notifSpecialDays.value) {
        await _notificationService.scheduleMilestones(profile.startDate);
      } else {
        await _notificationService.cancelMilestones();
      }
    } catch (e) {
      // Handle exact alarms permission error
      if (e.toString().contains('exact_alarms_not_permitted')) {
        Get.snackbar(
          'Permission Required',
          'Please enable "Alarms & reminders" permission in your device settings.\n\nGo to: Settings > Apps > Ours > Alarms & reminders',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 6),
          margin: const EdgeInsets.all(16),
        );
        
        // Reset toggles since we can't schedule
        notifMonthly.value = false;
        notifYearly.value = false;
        notifSpecialDays.value = false;
        _storage.write('notif_monthly', false);
        _storage.write('notif_yearly', false);
        _storage.write('notif_special_days', false);
      } else {
        // Other errors
        Get.snackbar(
          'Error',
          'Failed to schedule notifications: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }
  
  // Public method to be called when start date changes
  void rescheduleNotifications() {
    _updateSchedule();
  }

  // Get available themes
  List<String> get availableThemes => ['Black & Pink', 'Light', 'Dark'];
}
