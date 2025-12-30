import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:single/data/models/memory.dart';
import 'package:single/data/storage/memory_storage.dart';

class MemoryController extends GetxController {
  final RxList<Memory> memories = <Memory>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadMemories();
  }

  // Load all memories
  void loadMemories() {
    memories.value = MemoryStorage.getMemoriesSorted();
  }

  // Add memory
  Future<void> addMemory(Memory memory) async {
    await MemoryStorage.addMemory(memory);
    loadMemories();
  }

  // Update memory
  Future<void> updateMemory(Memory memory) async {
    await MemoryStorage.updateMemory(memory);
    loadMemories();
  }

  // Delete memory
  Future<void> deleteMemory(String id) async {
    await MemoryStorage.deleteMemory(id);
    loadMemories();
  }

  // Get memory by ID
  Memory? getMemory(String id) {
    return MemoryStorage.getMemory(id);
  }

  // Pick image from gallery
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return image?.path;
    } catch (e) {
      return null;
    }
  }

  // Pick image from camera
  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      return image?.path;
    } catch (e) {
      return null;
    }
  }

  // Get memories count
  int get memoriesCount => memories.length;
}
