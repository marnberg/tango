import 'dart:io';

import 'package:image/image.dart';

import 'config_model.dart';

Future scaleImages(
  String source,
  String destination,
  TangoConfig config,
) async {
  for (final fileEntry in config.scaledImages.entries) {
    final imageFile = File('$source/${fileEntry.value}').readAsBytesSync();
    final i = fileEntry.key.lastIndexOf('.');
    final type = fileEntry.key.substring(i + 1);

    final image = decodeImage(imageFile);

    final baseOutput = '$destination${fileEntry.key}';

    print('Scaling $source/${fileEntry.key} => $baseOutput');

    for (final scale in config.scalesMap.entries) {
      final dirIndex = baseOutput.lastIndexOf('/');
      final dirPath = baseOutput.substring(0, dirIndex) + scale.key;
      final fileName = baseOutput.substring(dirIndex + 1);
      final dir = await Directory(dirPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final resized = copyResize(image,
          width: (image.width * scale.value).toInt(),
          height: (image.height * scale.value).toInt());

      final destName = '$dirPath$fileName';
      switch (type) {
        case 'jpg':
        case 'jpeg':
          File(destName).writeAsBytesSync(encodeJpg(resized));
          break;
        case 'png':
          File(destName).writeAsBytesSync(encodePng(resized));
          break;
        default:
          exitCode = 1;
          stderr.writeln('unsupported image file');
          return;
      }
    }
  }
}
