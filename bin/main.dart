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

import 'dart:io';
import 'package:tango/tango.dart' as tango;
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

const tangoFile = 'tangofile';
const tangoFileAbbr = 't';

const sourceDirecory = 'source';
const sourceDirecoryAbbr = 's';

const destinationDirecory = 'destination';
const destinationDirecoryAbbr = 'd';

const version = 'version';
const versionAbbr = 'v';

ArgResults argResults;

void main(List<String> arguments) async {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addOption(tangoFile, abbr: tangoFileAbbr)
    ..addOption(sourceDirecory, abbr: sourceDirecoryAbbr)
    ..addOption(
      destinationDirecory,
      abbr: destinationDirecoryAbbr,
    )
    ..addFlag(version, abbr: versionAbbr);
  argResults = parser.parse(arguments);
  if (argResults[version] == true) {
    final yamlFile = File('pubspec.yaml');
    final text = await yamlFile.readAsString();
    Map yaml = loadYaml(text);
    print(yaml['version']);
    return;
  }

  if (argResults[sourceDirecory] == null) {
    final tangoYaml = File(argResults[tangoFile] ?? 'tango.yaml');
    final text = await tangoYaml.readAsString();
    Map yaml = loadYaml(text);
    final target = argResults.rest;
    if (target.length != 1) {
      exitCode = -1;
      return;
    }
    final config = yaml[target.first];
    if (config['source'] == null || config['config'] == null) {
      exitCode = -1;
      return;
    }
    final source = config['source'] as String;
    final destination =
        config['destination'] != null ? config['destination'] as String : null;
    final configFiles =
        (config['config'] as YamlList).map((i) => i as String).toList();

    await tango.handleConfigs(source, destination ?? '.', configFiles);
  } else {
    final configFiles = argResults.rest;
    await tango.handleConfigs(argResults[sourceDirecory],
        argResults[destinationDirecory] ?? '.', configFiles);
  }
}
