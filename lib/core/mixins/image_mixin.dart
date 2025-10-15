import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

mixin ImageMixin {
  Future<File?> base64ToFile({
    required String base64String,
    required String fileName,
  }) async {
    final List<int> bytes = base64Decode(base64String);
    final String? downloadPath = await _fileDownloadPath();
    if (downloadPath == null) return null;
    final File file = File('$downloadPath/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<String?> _fileDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      log('Cannot get download folder path');
    }
    return directory?.path;
  }

  Future<String> fileToBase64(
    File file,
  ) async =>
      base64Encode(await file.readAsBytes());

  void base64ToImageBytes(String base64) => base64Decode(base64);
}
