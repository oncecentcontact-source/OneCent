import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single/controllers/memory_controller.dart';
import 'package:single/data/models/memory.dart';
import 'package:intl/intl.dart';

class MemoryDetailPage extends StatelessWidget {
  const MemoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String memoryId = Get.arguments as String;
    final MemoryController memoryController = Get.find();
    final Memory? memory = memoryController.getMemory(memoryId);

    if (memory == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Memory')),
        body: const Center(child: Text('Memory not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, memoryController, memory.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo
            if (memory.photoPath != null && File(memory.photoPath!).existsSync())
              Hero(
                tag: 'memory_${memory.id}',
                child: Image.file(
                  File(memory.photoPath!),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 300,
                color: Theme.of(context).colorScheme.surface,
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    memory.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 16),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(memory.date),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  if (memory.note != null && memory.note!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // Note
                    Text(
                      'Note',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      memory.note!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    MemoryController controller,
    String memoryId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Memory'),
          content: const Text('Are you sure you want to delete this memory? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteMemory(memoryId);
                Navigator.pop(context); // Close dialog
                Get.back(); // Go back to memories list
                Get.snackbar(
                  'Deleted',
                  'Memory deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
