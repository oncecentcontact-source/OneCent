import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/controllers/profile_controller.dart';
import 'package:single/controllers/settings_controller.dart';
import 'package:single/controllers/memory_controller.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _shouldRefresh = false;

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final SettingsController settingsController = Get.find();
    final MemoryController memoryController = Get.find();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back(result: _shouldRefresh);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(result: _shouldRefresh),
          ),
        ),
      body: Obx(() {
        final profile = profileController.profile.value;
        
        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Edit Names
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: Text('${profile.nameA} & ${profile.nameB}'),
                      subtitle: const Text('Tap to edit names'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditNamesDialog(context, profileController, profile),
                    ),
                    
                    const Divider(),
                    
                    // Edit Start Date
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(DateFormat('MMMM dd, yyyy').format(profile.startDate)),
                      subtitle: const Text('Tap to edit start date'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDateDialog(context, profileController, profile),
                    ),
                    
                    const Divider(),
                    
                    // Edit Profile Photos
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Profile Photos'),
                      subtitle: const Text('Tap to update photos'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditPhotosDialog(context, profileController, memoryController, profile),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notification Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Monthly Anniversary
                    Obx(() => SwitchListTile(
                      title: const Text('Monthly Anniversary'),
                      subtitle: const Text('Remind me every month'),
                      value: settingsController.notifMonthly.value,
                      onChanged: settingsController.toggleMonthly,
                      activeColor: Theme.of(context).colorScheme.primary,
                    )),
                    
                    // Yearly Anniversary
                    Obx(() => SwitchListTile(
                      title: const Text('Yearly Anniversary'),
                      subtitle: const Text('Remind me every year'),
                      value: settingsController.notifYearly.value,
                      onChanged: settingsController.toggleYearly,
                      activeColor: Theme.of(context).colorScheme.primary,
                    )),
                    
                    // Special Days
                    Obx(() => SwitchListTile(
                      title: const Text('Special Days'),
                      subtitle: const Text('100, 200, 300 days...'),
                      value: settingsController.notifSpecialDays.value,
                      onChanged: settingsController.toggleSpecialDays,
                      activeColor: Theme.of(context).colorScheme.primary,
                    )),
                    
                    const Divider(),
                    
                    // Test Notification Button
                    ListTile(
                      leading: Icon(Icons.notifications_active, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Test Notification'),
                      subtitle: const Text('Tap to receive a test notification in 10 seconds'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await settingsController.sendTestNotification();
                          Get.snackbar(
                            'Test Scheduled',
                            'You will receive a notification in 10 seconds!',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 3),
                          );
                        },
                        child: const Text('Test'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Theme Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Theme selector
                    ...settingsController.availableThemes.map((theme) {
                      return Obx(() {
                        return InkWell(
                          onTap: () => settingsController.changeTheme(theme),
                          child: RadioListTile<String>(
                            title: Text(theme),
                            value: theme,
                            groupValue: settingsController.themeName.value,
                            selected: settingsController.themeName.value == theme,
                            activeColor: Theme.of(context).colorScheme.primary,
                            toggleable: false,
                            onChanged: (_) => settingsController.changeTheme(theme),
                          ),
                        );
                      });
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Version'),
                      subtitle: const Text('1.0.0'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    ));
  }

  void _showEditNamesDialog(BuildContext context, ProfileController controller, profile) {
    final nameAController = TextEditingController(text: profile.nameA);
    final nameBController = TextEditingController(text: profile.nameB);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Names'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameAController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameBController,
                decoration: const InputDecoration(
                  labelText: 'Second Name',
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameAController.text.trim().isNotEmpty &&
                    nameBController.text.trim().isNotEmpty) {
                  controller.updateProfile(
                    nameA: nameAController.text.trim(),
                    nameB: nameBController.text.trim(),
                  );
                  setState(() => _shouldRefresh = true);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDateDialog(BuildContext context, ProfileController controller, profile) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: profile.startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateProfile(startDate: picked);
      setState(() => _shouldRefresh = true);
    }
  }

  void _showEditPhotosDialog(
    BuildContext context,
    ProfileController profileController,
    MemoryController memoryController,
    profile,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Profile Photos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final path = await memoryController.pickImageFromGallery();
                  if (path != null) {
                    await profileController.updateProfile(avatarAPath: path);
                    setState(() => _shouldRefresh = true);
                  }
                },
                icon: const Icon(Icons.person),
                label: Text('Update ${profile.nameA}\'s Photo'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final path = await memoryController.pickImageFromGallery();
                  if (path != null) {
                    await profileController.updateProfile(avatarBPath: path);
                    setState(() => _shouldRefresh = true);
                  }
                },
                icon: const Icon(Icons.person_outline),
                label: Text('Update ${profile.nameB}\'s Photo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
