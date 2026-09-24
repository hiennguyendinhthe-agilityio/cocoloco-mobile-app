import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';

import 'web_file_service.dart';

/// Service using the file package: ^7.0.1
/// This package provides an abstraction layer for the file system.
class FilePackageService {
  // Constructor with an optional FileSystem (useful for testing)
  FilePackageService({FileSystem? fileSystem, String? basePath})
    : _fileSystem = fileSystem ?? _getDefaultFileSystem(),
      _basePath = basePath ?? _getDefaultBasePath();

  // FileSystem instance - can be LocalFileSystem or MemoryFileSystem
  final FileSystem _fileSystem;
  final String _basePath;

  /// Gets the default FileSystem based on the platform.
  static FileSystem _getDefaultFileSystem() {
    if (kIsWeb) {
      // Web uses WebFileService's MemoryFileSystem
      return WebFileService.instance.fileSystem;
    } else {
      // Mobile/Desktop use LocalFileSystem
      return const LocalFileSystem();
    }
  }

  /// Gets the default base path based on the platform.
  static String _getDefaultBasePath() {
    if (kIsWeb) {
      // Web uses WebFileService's base path
      return '/web_app_storage';
    } else {
      // Mobile/Desktop use a relative path
      return '/app_documents';
    }
  }

  /// Initializes the service (especially important for web).
  Future<void> initialize() async {
    if (kIsWeb) {
      await WebFileService.instance.initialize();
    } else {
      // Create the base directory for mobile/desktop
      if (!await _documentsDirectory.exists()) {
        await _documentsDirectory.create(recursive: true);
      }
    }
  }

  /// Gets the application's documents directory.
  Directory get _documentsDirectory {
    return _fileSystem.directory(_basePath);
  }

  /// Creates a file reference.
  File _getFile(String fileName) {
    final directory = _documentsDirectory;
    return directory.childFile(fileName);
  }

  /// Creates a directory reference.
  Directory _getDirectory(String dirName) {
    final directory = _documentsDirectory;
    return directory.childDirectory(dirName);
  }

  // ==================== FILE OPERATIONS ====================

  /// Writes content to a file.
  Future<void> writeFile(String fileName, String content) async {
    final file = _getFile(fileName);
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  /// Reads the content of a file.
  Future<String> readFile(String fileName) async {
    final file = _getFile(fileName);

    if (await file.exists()) {
      return await file.readAsString();
    }
    throw FileSystemException('File not found: $fileName');
  }

  /// Appends content to the end of a file.
  Future<void> appendToFile(String fileName, String content) async {
    final file = _getFile(fileName);

    if (await file.exists()) {
      final existingContent = await file.readAsString();
      await file.writeAsString('$existingContent\n$content');
    } else {
      await file.create(recursive: true);
      await file.writeAsString(content);
    }
  }

  /// Deletes a file.
  Future<void> deleteFile(String fileName) async {
    final file = _getFile(fileName);

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Checks if a file exists.
  Future<bool> fileExists(String fileName) async {
    final file = _getFile(fileName);
    return await file.exists();
  }

  /// Copies a file.
  Future<void> copyFile(String sourceFileName, String targetFileName) async {
    final sourceFile = _getFile(sourceFileName);
    final targetFile = _getFile(targetFileName);

    if (await sourceFile.exists()) {
      await sourceFile.copy(targetFile.path);
    } else {
      throw FileSystemException('Source file not found: $sourceFileName');
    }
  }

  /// Moves/Renames a file.
  Future<void> moveFile(String oldFileName, String newFileName) async {
    final oldFile = _getFile(oldFileName);
    final newFile = _getFile(newFileName);

    if (await oldFile.exists()) {
      await oldFile.rename(newFile.path);
    } else {
      throw FileSystemException('File not found: $oldFileName');
    }
  }

  /// Gets information about a file.
  Future<Map<String, dynamic>> getFileInfo(String fileName) async {
    final file = _getFile(fileName);

    if (await file.exists()) {
      final stat = await file.stat();
      return {
        'path': file.path,
        'name': file.basename,
        'size': stat.size,
        'modified': stat.modified.toIso8601String(),
        'type': stat.type.toString(),
        'exists': true,
      };
    }

    return {'exists': false};
  }

  // ==================== DIRECTORY OPERATIONS ====================

  /// Creates a directory.
  Future<void> createDirectory(String dirName) async {
    final directory = _getDirectory(dirName);
    await directory.create(recursive: true);
  }

  /// Deletes a directory.
  Future<void> deleteDirectory(String dirName) async {
    final directory = _getDirectory(dirName);

    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  /// Lists the contents of a directory.
  Future<List<Map<String, dynamic>>> listDirectory(String dirName) async {
    final directory = _getDirectory(dirName);

    if (await directory.exists()) {
      final entities = await directory.list().toList();

      return entities.map((entity) {
        return {
          'name': entity.basename,
          'path': entity.path,
          'type': entity is File ? 'file' : 'directory',
        };
      }).toList();
    }

    return [];
  }

  /// Checks if a directory exists.
  Future<bool> directoryExists(String dirName) async {
    final directory = _getDirectory(dirName);
    return await directory.exists();
  }

  // ==================== ADVANCED OPERATIONS ====================

  /// Finds files by a pattern.
  Future<List<String>> findFiles(String pattern, {String? inDirectory}) async {
    final searchDir = inDirectory != null
        ? _getDirectory(inDirectory)
        : _documentsDirectory;

    if (!await searchDir.exists()) {
      return [];
    }

    final results = <String>[];
    await for (final entity in searchDir.list(recursive: true)) {
      if (entity is File && entity.basename.contains(pattern)) {
        results.add(entity.basename);
      }
    }

    return results;
  }

  /// Gets the size of a directory.
  Future<int> getDirectorySize(String dirName) async {
    final directory = _getDirectory(dirName);

    if (!await directory.exists()) {
      return 0;
    }

    int totalSize = 0;
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        final stat = await entity.stat();
        totalSize += stat.size;
      }
    }

    return totalSize;
  }

  /// Backs up a file with a timestamp.
  Future<void> backupFile(String fileName) async {
    final file = _getFile(fileName);

    if (await file.exists()) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupName = '${fileName}_backup_$timestamp';
      await copyFile(fileName, backupName);
    }
  }

  /// Gets a list of all files.
  Future<List<String>> getAllFiles() async {
    final directory = _documentsDirectory;
    final files = <String>[];

    // Create the directory if it doesn't exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        files.add(entity.basename);
      }
    }

    return files;
  }

  /// Cleans up - deletes files older than the specified number of days.
  Future<int> cleanupOldFiles(int daysOld) async {
    final directory = _documentsDirectory;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    int deletedCount = 0;

    if (!await directory.exists()) {
      return 0;
    }

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        final stat = await entity.stat();
        if (stat.modified.isBefore(cutoffDate)) {
          await entity.delete();
          deletedCount++;
        }
      }
    }

    return deletedCount;
  }

  // ==================== UTILITY METHODS ====================

  /// Gets the FileSystem instance (useful for testing).
  FileSystem get fileSystem => _fileSystem;

  /// Creates a MemoryFileSystem for testing.
  static FilePackageService createMemoryFileSystem() {
    return FilePackageService(fileSystem: MemoryFileSystem());
  }

  /// Formats the file size.
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
