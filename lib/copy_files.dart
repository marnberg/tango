
import 'dart:io';

import 'config_model.dart';


Future copyFiles(
  String source,
  String destination,
  TangoConfig config,
) async {
  for (final fileEntry in config.copied.entries) {
    final input = '$source/${fileEntry.value}';
    final outout = '$destination/${fileEntry.key}';
    final dirIndex = outout.lastIndexOf('/');
    final dirPath = outout.substring(0, dirIndex);
    final dir = await Directory(dirPath);
    if (!dir.existsSync()) {
      print('Creating $dirPath');
      dir.createSync(recursive: true);
    }

    print('Copying Files $input => $outout');
    final file = File(input);
    file.copySync(outout);
  }
}