import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/controllers/checkin_controller.dart';
import 'package:intl/intl.dart';

class CheckInHistoryPage extends StatelessWidget {
  const CheckInHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckInController checkInController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeling History'),
      ),
      body: Obx(() {
        if (checkInController.checkIns.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  'No feelings recorded yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start checking in daily to track your mood',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Average mood card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Average Mood',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${checkInController.averageMood.toStringAsFixed(1)} / 5.0',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Total Feelings',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${checkInController.checkInsCount}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Check-in list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: checkInController.checkIns.length,
                itemBuilder: (context, index) {
                  final checkIn = checkInController.checkIns[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Text(
                        checkIn.moodEmoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                      title: Text(
                        checkIn.moodLabel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(checkIn.date),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (checkIn.note != null && checkIn.note!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              checkIn.note!,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
