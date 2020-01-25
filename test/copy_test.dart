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
