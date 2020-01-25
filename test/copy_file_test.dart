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

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tango/config_model.dart';
import 'package:tango/copy_files.dart';

import 'io_mock.dart';

void main() {
  group('File Copy', () {
    test('Copy files when destination exists', () async {
      final config = TangoConfig(copied: {'foo': 'bar'});
      final mockDir = MockDirectory();
      final mockFile = MockFile();

      when(mockDir.existsSync()).thenAnswer((_) => true);
      when(mockFile.createSync()).thenAnswer((_) => mockFile);

      await IOOverrides.runZoned(
        () async {
          await copyFiles('./source', './destination', config);
          verify(mockDir.existsSync());
          verifyNever(mockDir.createSync());
          verify(mockFile.copySync('./destination/foo'));
        },
        createDirectory: (String path) => mockDir,
        createFile: (String path) => mockFile,
      );
    });

    test('Create destination when it does not exist', () async {
      final config = TangoConfig(copied: {'foo': 'bar'});
      final mockDir = MockDirectory();
      final mockFile = MockFile();

      when(mockDir.existsSync()).thenAnswer((_) => false);
      when(mockFile.createSync()).thenAnswer((_) => mockFile);

      await IOOverrides.runZoned(
        () async {
          await copyFiles('./source', './destination', config);
          verify(mockDir.existsSync());
          verify(mockDir.createSync(recursive: true));
          verify(mockFile.copySync('./destination/foo'));
        },
        createDirectory: (String path) => mockDir,
        createFile: (String path) => mockFile,
      );
    });
  });
}
