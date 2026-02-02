import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class UpiQrDownloader {
  static Future<String?> saveQrToDownloads(GlobalKey repaintKey) async {
    try {
      // Wait for frame to paint
      await Future.delayed(const Duration(milliseconds: 50));

      final boundary = repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();

      // Correct directory
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (directory == null) return null;

      final file = File(
        '${directory.path}/upi_qr_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      debugPrint("QR save error: $e");
      return null;
    }
  }
}
