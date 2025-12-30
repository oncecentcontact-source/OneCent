import 'package:hive/hive.dart';
import 'package:single/data/models/memory.dart';

class MemoryStorage {
  static const String _boxName = 'memories';

  // Get the box
  static Box<Memory> get _box => Hive.box<Memory>(_boxName);

  // Initialize the box
  static Future<void> init() async {
    await Hive.openBox<Memory>(_boxName);
  }

  // Add memory
  static Future<void> addMemory(Memory memory) async {
    await _box.put(memory.id, memory);
  }

  // Get all memories
  static List<Memory> getAllMemories() {
    return _box.values.toList();
  }

  // Get memory by ID
  static Memory? getMemory(String id) {
    return _box.get(id);
  }

  // Update memory
  static Future<void> updateMemory(Memory memory) async {
    await _box.put(memory.id, memory);
  }

  // Delete memory
  static Future<void> deleteMemory(String id) async {
    await _box.delete(id);
  }

  // Get memories sorted by date (newest first)
  static List<Memory> getMemoriesSorted() {
    final memories = getAllMemories();
    memories.sort((a, b) => b.date.compareTo(a.date));
    return memories;
  }

  // Get memories count
  static int getMemoriesCount() {
    return _box.length;
  }

  // Clear all memories
  static Future<void> clearAll() async {
    await _box.clear();
  }

  // Close box
  static Future<void> close() async {
    await _box.close();
  }
}
