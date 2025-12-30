import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/controllers/checkin_controller.dart';
import 'package:single/data/models/checkin.dart';
import 'package:single/routes/app_pages.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final CheckInController _checkInController = Get.find();
  final _noteController = TextEditingController();
  int _selectedMood = 3;

  @override
  void initState() {
    super.initState();
    // Load existing check-in if available
    final todayCheckIn = _checkInController.todayCheckIn.value;
    if (todayCheckIn != null) {
      _selectedMood = todayCheckIn.mood;
      _noteController.text = todayCheckIn.note ?? '';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveCheckIn() {
    final checkIn = CheckIn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      mood: _selectedMood,
      note: _noteController.text.trim().isEmpty 
          ? null 
          : _noteController.text.trim(),
    );

    _checkInController.saveCheckIn(checkIn);
    Get.back();
    Get.snackbar(
      'Success',
      'Feeling saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Feeling'),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(AppPages.checkInHistory),
            child: const Text('History'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Title
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Mood selector
            _buildMoodSelector(),

            const SizedBox(height: 40),

            // Selected mood display
            Center(
              child: Column(
                children: [
                  Text(
                    _getMoodEmoji(_selectedMood),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMoodLabel(_selectedMood),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Note input
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Add a note (Optional)',
                hintText: 'What made you feel this way?',
                prefixIcon: Icon(Icons.note),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
            ),

            const SizedBox(height: 40),

            // Save button
            ElevatedButton(
              onPressed: _saveCheckIn,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Save Feeling'),
              ),
            ),

            const SizedBox(height: 16),

            // Info text
            Obx(() {
              if (_checkInController.hasCheckedInToday) {
                return Text(
                  'You already recorded your feeling today. This will update it.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final mood = index + 1;
        final isSelected = _selectedMood == mood;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              _getMoodEmoji(mood),
              style: TextStyle(
                fontSize: isSelected ? 40 : 32,
              ),
            ),
          ),
        );
      }),
    );
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😍';
      default:
        return '😐';
    }
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Okay';
      case 4:
        return 'Happy';
      case 5:
        return 'Very Happy';
      default:
        return 'Okay';
    }
  }
}
