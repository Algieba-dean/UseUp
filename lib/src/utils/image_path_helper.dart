import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImagePathHelper {
  static Future<String?> getDisplayPath(String? storedPath) async {
    if (storedPath == null) return null;

    // If it looks like a full path and exists, use it (Legacy support)
    final file = File(storedPath);
    if (await file.exists()) {
      return storedPath;
    }

    // If it's a filename (no separators) or the full path doesn't exist (changed container),
    // try to find it in the AppDocumentsDirectory.
    final directory = await getApplicationDocumentsDirectory();
    final fileName = storedPath.split('/').last; // Extract filename
    final newPath = '${directory.path}/$fileName';
    
    final newFile = File(newPath);
    if (await newFile.exists()) {
      return newPath;
    }

    // If still not found, return null or original (to let Image widget fail gracefully)
    return null;
  }
}
