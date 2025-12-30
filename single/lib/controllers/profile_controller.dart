import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/data/models/couple.dart';
import 'package:single/data/storage/profile_storage.dart';
import 'package:single/controllers/settings_controller.dart';

class ProfileController extends GetxController {
  final Rx<CoupleProfile?> profile = Rx<CoupleProfile?>(null);
  final RxInt imageUpdateKey = 0.obs; // Key to force image rebuild

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // Load profile from storage
  void loadProfile() {
    profile.value = ProfileStorage.getProfile();
  }

  // Save profile
  Future<void> saveProfile(CoupleProfile newProfile) async {
    await ProfileStorage.saveProfile(newProfile);
    profile.value = newProfile;
  }



  // Update profile
  Future<void> updateProfile({
    String? nameA,
    String? nameB,
    DateTime? startDate,
    String? avatarAPath,
    String? avatarBPath,
  }) async {
    await ProfileStorage.updateProfile(
      nameA: nameA,
      nameB: nameB,
      startDate: startDate,
      avatarAPath: avatarAPath,
      avatarBPath: avatarBPath,
    );
    
    // Clear image cache for updated avatars to force refresh
    if (avatarAPath != null) {
      final file = File(avatarAPath);
      if (file.existsSync()) {
        imageCache.evict(FileImage(file));
      }
      imageUpdateKey.value++; // Increment to force rebuild
    }
    if (avatarBPath != null) {
      final file = File(avatarBPath);
      if (file.existsSync()) {
        imageCache.evict(FileImage(file));
      }
      imageUpdateKey.value++; // Increment to force rebuild
    }
    
    loadProfile(); // Reload to update UI
    
    // Reschedule notifications if start date changed
    if (startDate != null) {
      if (Get.isRegistered<SettingsController>()) {
        Get.find<SettingsController>().rescheduleNotifications();
      }
    }
  }

  // Check if profile exists
  bool hasProfile() {
    return ProfileStorage.hasProfile();
  }

  // Get days together
  int get daysTogether {
    return profile.value?.daysTogether ?? 0;
  }

  // Get days until anniversary
  int get daysUntilAnniversary {
    return profile.value?.daysUntilAnniversary ?? 0;
  }

  // Get next anniversary
  DateTime? get nextAnniversary {
    return profile.value?.nextAnniversary;
  }
}
