import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/controllers/memory_controller.dart';
import 'package:single/routes/app_pages.dart';
import 'package:intl/intl.dart';

class MemoriesListPage extends StatelessWidget {
  const MemoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MemoryController memoryController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
      ),
      body: Obx(() {
        if (memoryController.memories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  'No memories yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add your first memory',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: memoryController.memories.length,
          itemBuilder: (context, index) {
            final memory = memoryController.memories[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    AppPages.memoryDetail,
                    arguments: memory.id,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Photo thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: memory.photoPath != null &&
                                  File(memory.photoPath!).existsSync()
                              ? Image.file(
                                  File(memory.photoPath!),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Theme.of(context).colorScheme.surface,
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Title and date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                memory.title,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('MMM dd, yyyy').format(memory.date),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppPages.addMemory),
        child: const Icon(Icons.add),
      ),
    );
  }
}
