import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/controllers/profile_controller.dart';
import 'package:single/routes/app_pages.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileController profileController = Get.find();

  Future<void> _handleSettings() async {
    final result = await Get.toNamed(AppPages.settings);
    if (result == true) {
      debugPrint("MAKE UPDATE - Clearing Cache & Rebuilding");
      
      // Clear cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      
      // Reload profile data
      profileController.loadProfile();
      profileController.imageUpdateKey.value++;
      
      // Force widget rebuild
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Ours Days'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _handleSettings,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Obx(() {
          final profile = profileController.profile.value;
          
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
            child: Column(
              children: [
                // Profile Images with Names
                _buildProfileSection(context, profileController, profile),
                
                const SizedBox(height: 40),
                
                // Days Together Counter
                _buildDaysCounter(context, profile),
                
                const SizedBox(height: 40),
                
                // Anniversary Countdown
                _buildAnniversaryCard(
                  context,
                  profile.nextAnniversary,
                  profile.daysUntilAnniversary,
                ),
                
                const SizedBox(height: 40),
                
                // Quick Action Buttons
                _buildQuickActions(context),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, ProfileController profileController, profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProfileAvatar(
          context,
          profileController,
          profile.nameA,
          profile.avatarAPath,
        ),
        Column(
          children: [
            Icon(
              Icons.favorite,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              'Forever',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        _buildProfileAvatar(
          context,
          profileController,
          profile.nameB,
          profile.avatarBPath,
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(BuildContext context, ProfileController profileController, String name, String? avatarPath) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Obx(() {
            final updateKey = profileController.imageUpdateKey.value;
            return CircleAvatar(
              key: ValueKey('$avatarPath-$updateKey'), // Force rebuild when image changes
              radius: 55,
              backgroundColor: Theme.of(context).colorScheme.surface,
              backgroundImage: avatarPath != null && File(avatarPath).existsSync()
                  ? FileImage(File(avatarPath), scale: 1.0 + (updateKey * 0.00001))
                  : null,
              child: avatarPath == null || !File(avatarPath).existsSync()
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDaysCounter(BuildContext context, profile) {
    final detail = profile.durationDetail;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: Column(
              children: [
                // Main Days Counter
                Text(
                  '${profile.daysTogether}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 80,
                    height: 1,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Days in Love',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Detailed Duration
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailItem(context, '${detail['years']}', 'Years'),
                      _buildDivider(context),
                      _buildDetailItem(context, '${detail['months']}', 'Months'),
                      _buildDivider(context),
                      _buildDetailItem(context, '${detail['days']}', 'Days'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
    );
  }

  Widget _buildAnniversaryCard(
    BuildContext context,
    DateTime nextAnniversary,
    int daysUntil,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                  (Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Next Anniversary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('MMMM dd, yyyy').format(nextAnniversary),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$daysUntil days left',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.photo_library_outlined,
                  label: 'Memories',
                  onTap: () => Get.toNamed(AppPages.memories),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.favorite_border,
                  label: 'Today\'s Feeling',
                  onTap: () => Get.toNamed(AppPages.checkIn),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
