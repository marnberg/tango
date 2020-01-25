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

import 'package:image/image.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tango/config_model.dart';

import 'package:tango/scale_images.dart';
import 'io_mock.dart';

class MockTangoImageUtils extends Mock implements TangoImageUtils {}

class MockImage extends Mock implements Image {}

void main() {
  group('Scale Image', () {
    test('Scale images and place them in correct desination', () async {
      final config = TangoConfig(scaledImages: {'foo.jpg': 'bar.png'});
      final mockDir = MockDirectory();
      final imagaeUtils = MockTangoImageUtils();
      final image = MockImage();

      when(imagaeUtils.readImage(any)).thenAnswer((_) => image);
      when(imagaeUtils.resize(any, width: any, height: any))
          .thenAnswer((_) => image);

      when(image.width).thenAnswer((_) => 100);
      when(image.height).thenAnswer((_) => 100);

      when(mockDir.existsSync()).thenAnswer((_) => true);

      await IOOverrides.runZoned(
        () async {
          await scaleImages('./source', './destination', config,
              imageUtils: imagaeUtils);
          verify(mockDir.existsSync());
          verifyNever(mockDir.createSync());
          verify(imagaeUtils.readImage('./source/bar.png'));
          verify(imagaeUtils.writeImage(any, './4.0x/destinationfoo.jpg'));
          verify(imagaeUtils.writeImage(any, './3.0x/destinationfoo.jpg'));
          verify(imagaeUtils.writeImage(any, './2.0x/destinationfoo.jpg'));
          verify(imagaeUtils.writeImage(any, './destinationfoo.jpg'));
        },
        createDirectory: (String path) => mockDir,
      );
    });
  });
}
