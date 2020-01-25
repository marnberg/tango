/*
BSD 3-Clause License

Copyright (c) 2020, Martin Arnberg marnberg@gmail.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import 'dart:convert';
import 'dart:io';

import 'app_assets.dart';
import 'config_model.dart';
import 'copy_files.dart';
import 'scale_images.dart';

Future handleConfigs(
  String source,
  String destination,
  List<String> configFiles,
) async {
  final outputDir = await Directory(destination);
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
  await scaleImages(source, destination, config);
  await createIosAssets(source, destination, config);
  await createAndroidAssets(source, destination, config);

  return;
}
