import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Cihazda üretilen dosyayı (dışa aktarılan veri, rapor görseli) sistem paylaşım menüsüyle
/// verir; internet gerekmez. Geçici klasöre yazılır, sistem gerektiğinde siler.
Future<void> shareFile(Uint8List bytes, String name, String mime) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$name');
  await file.writeAsBytes(bytes, flush: true);
  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path, mimeType: mime)]),
  );
}
