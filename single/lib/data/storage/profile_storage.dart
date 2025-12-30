import 'package:hive/hive.dart';
import 'package:single/data/models/couple.dart';

class ProfileStorage {
  static const String _boxName = 'coupleProfile';
  static const String _profileKey = 'profile';

  // Get the box
  static Box<CoupleProfile> get _box => Hive.box<CoupleProfile>(_boxName);

  // Initialize the box
  static Future<void> init() async {
    await Hive.openBox<CoupleProfile>(_boxName);
  }

  // Save profile
  static Future<void> saveProfile(CoupleProfile profile) async {
    await _box.put(_profileKey, profile);
  }

  // Get profile
  static CoupleProfile? getProfile() {
    return _box.get(_profileKey);
  }

  // Check if profile exists
  static bool hasProfile() {
    return _box.containsKey(_profileKey);
  }

  // Update profile
  static Future<void> updateProfile({
    String? nameA,
    String? nameB,
    DateTime? startDate,
    String? avatarAPath,
    String? avatarBPath,
  }) async {
    final profile = getProfile();
    if (profile != null) {
      if (nameA != null) profile.nameA = nameA;
      if (nameB != null) profile.nameB = nameB;
      if (startDate != null) profile.startDate = startDate;
      if (avatarAPath != null) profile.avatarAPath = avatarAPath;
      if (avatarBPath != null) profile.avatarBPath = avatarBPath;
      await profile.save();
    }
  }

  // Delete profile
  static Future<void> deleteProfile() async {
    await _box.delete(_profileKey);
  }

  // Close box
  static Future<void> close() async {
    await _box.close();
  }
}
