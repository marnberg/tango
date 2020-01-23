import 'dart:convert';
import 'dart:io';

import 'config_model.dart';
import 'copy_files.dart';

Future handleConfigs(
  String source,
  String destination,
  List<String> configFiles,
) async {
  final outputDir = await Directory(destination);
  outputDir.deleteSync(recursive: true);
  outputDir.createSync(recursive: true);

  var config = TangoConfig();

  for (var configFile in configFiles) {
    config = await File('$source/$configFile')
        .readAsString()
        .then((fileContents) => json.decode(fileContents))
        .then((jsonData) {
      print(jsonData);
      return config.merge(TangoConfig.fromJson(jsonData));
    });
  }

  await copyFiles(source, destination, config);

  return;
}
