import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class Screenshotter {
  static Future<void> shareScreenshot(
      {required BuildContext context,
      required GlobalKey key,
      required String filename}) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    Uint8List memoryImageData = bytes!.buffer.asUint8List();
    if (kIsWeb) {
      await FilePicker.platform.saveFile(
        dialogTitle: 'Save Image',
        fileName: filename,
        bytes: memoryImageData,
      );
    } else {
      await Share.shareXFiles(
          [XFile.fromData(memoryImageData, mimeType: 'image/png')],
          fileNameOverrides: [filename]);
    }
  }
}
