import 'package:file/file.dart';
import 'package:file/memory.dart';

class WebFileService {
  WebFileService._();

  static final WebFileService instance = WebFileService._();

  final MemoryFileSystem fileSystem = MemoryFileSystem();
  final String basePath = '/web_app_storage';
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    final dir = fileSystem.directory(basePath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _initialized = true;
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    await initialize();
    int fileCount = 0;
    int totalSize = 0;

    final dir = fileSystem.directory(basePath);
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          fileCount++;
          totalSize += await entity.length();
        }
      }
    }

    return {
      'platform': 'Web Browser',
      'file_system': 'MemoryFileSystem',
      'file_count': fileCount,
      'total_size': totalSize,
      'base_path': basePath,
      'persistent': 'No (In-memory storage resets on page refresh)',
      'note': 'Web storage runs in memory. For persistent web storage, consider IndexedDB or LocalStorage.',
    };
  }
}
