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

import 'dart:core';
import 'dart:io';

import 'package:image/image.dart';
import 'config_model.dart';

const Map<String, double> _iOSLaunchSizes = {
  'LaunchImage.png': 0.3334,
  'LaunchImage@2x.png': 0.6667,
  'LaunchImage@3x.png': 1,
};

const _iOSAppIconSizes = {
  'Icon-App-20x20@1x.png': 20,
  'Icon-App-20x20@2x.png': 40,
  'Icon-App-20x20@3x.png': 60,
  'Icon-App-29x29@1x.png': 29,
  'Icon-App-29x29@2x.png': 58,
  'Icon-App-29x29@3x.png': 87,
  'Icon-App-40x40@1x.png': 40,
  'Icon-App-40x40@2x.png': 80,
  'Icon-App-40x40@3x.png': 120,
  'Icon-App-60x60@2x.png': 120,
  'Icon-App-60x60@3x.png': 180,
  'Icon-App-76x76@1x.png': 76,
  'Icon-App-76x76@2x.png': 152,
  'Icon-App-83.5x83.5@2x.png': 167,
  'Icon-App-1024x1024@1x.png': 1024,
};

const _macAppIconSizes = {
  'app_icon_16.png': 16,
  'app_icon_32.png': 32,
  'app_icon_64.png': 64,
  'app_icon_128.png': 128,
  'app_icon_256.png': 256,
  'app_icon_512.png': 512,
  'app_icon_1024.png': 1024,
};

const _androidIconSizes = {
  'mdpi': 48,
  'hdpi': 72,
  'xhdpi': 96,
  'xxhdpi': 144,
  'xxxhdpi': 192
};

const Map<String, double> _androidLaunchSizes = {
  'mdpi': 0.25, // 1
  'hdpi': 0.3334, //1.5x
  'xhdpi': 0.5, // 2x
  'xxhdpi': 0.6667, // 3x
  'xxxhdpi': 1, // 4x
};

const _androidNotificationIconSizes = {
  'mdpi': 24,
  'hdpi': 36,
  'xhdpi': 48,
  'xxhdpi': 72,
  'xxxhdpi': 96
};

Future createIosAssets(
  String source,
  String destination,
  TangoConfig config,
) async {
  if (config.iosConfig != null) {
    print('Creating iOS Assets');

    if (config.iosConfig.launchImage != null) {
      print(' - Launch Images');
      final destPath =
          '$destination/ios/Runner/Assets.xcassets/LaunchImage.imageset';
      final dir = await Directory(destPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final iosLaunchImageFile =
          File('$source/${config.iosConfig.launchImage}').readAsBytesSync();
      final iosLaunchImage = decodeImage(iosLaunchImageFile);

      for (final scale in _iOSLaunchSizes.entries) {
        final resized = copyResize(iosLaunchImage,
            width: (iosLaunchImage.width * scale.value).toInt(),
            height: (iosLaunchImage.height * scale.value).toInt());
        File('$destPath/${scale.key}').writeAsBytesSync(encodePng(resized));
      }
    }

    if (config.iosConfig.iconImage != null) {
      print(' - App Icons');
      final destPath =
          '$destination/ios/Runner/Assets.xcassets/AppIcon.appiconset';
      final dir = await Directory(destPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final iosIconImageFile =
          File('$source/${config.iosConfig.iconImage}').readAsBytesSync();
      final iosIconImage = decodeImage(iosIconImageFile);

      for (final size in _iOSAppIconSizes.entries) {
        final resized = copyResize(iosIconImage,
            width: (size.value).toInt(), height: (size.value).toInt());
        File('$destPath/${size.key}').writeAsBytesSync(encodePng(resized));
      }
    }
  }
}

Future createMacAssets(
  String source,
  String destination,
  TangoConfig config,
) async {
  if (config.macConfig != null) {
    print('Creating Mac Assets');
    if (config.macConfig.iconImage != null) {
      print(' - App Icons');
      final destPath =
          '$destination/macos/Runner/Assets.xcassets/AppIcon.appiconset';
      final dir = await Directory(destPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final macIconImageFile =
          File('$source/${config.macConfig.iconImage}').readAsBytesSync();
      final iosIconImage = decodeImage(macIconImageFile);

      for (final size in _macAppIconSizes.entries) {
        final resized = copyResize(iosIconImage,
            width: (size.value).toInt(), height: (size.value).toInt());
        File('$destPath/${size.key}').writeAsBytesSync(encodePng(resized));
      }
    }
  }
}

Future createAndroidAssets(
  String source,
  String destination,
  TangoConfig config,
) async {
  if (config.androidConfig != null) {
    print('Creating Android Asets');

    if (config.androidConfig.launchImage != null) {
      print(' - Launch Images');

      final androidLaunchImageFile =
          File('$source/${config.androidConfig.launchImage}').readAsBytesSync();
      final androidLaunchImage = decodeImage(androidLaunchImageFile);

      for (final scale in _androidLaunchSizes.entries) {
        final destPath =
            '$destination/android/app/src/main/res/mipmap-${scale.key}';
        final dir = await Directory(destPath);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        final resized = copyResize(androidLaunchImage,
            width: (androidLaunchImage.width * scale.value).toInt(),
            height: (androidLaunchImage.height * scale.value).toInt());
        File('$destPath/launch_image.png').writeAsBytesSync(encodePng(resized));
      }
    }

    if (config.androidConfig.iconImage != null) {
      print(' - App Icons');
      final androidIconImageFile =
          File('$source/${config.androidConfig.iconImage}').readAsBytesSync();
      final androidIconImage = decodeImage(androidIconImageFile);

      for (final size in _androidIconSizes.entries) {
        final destPath =
            '$destination/android/app/src/main/res/mipmap-${size.key}';
        final dir = await Directory(destPath);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        final resized = copyResize(androidIconImage,
            width: (size.value).toInt(), height: (size.value).toInt());
        File('$destPath/ic_launcher.png').writeAsBytesSync(encodePng(resized));
      }
    }
    if (config.androidConfig.notificationImage != null) {
      print(' - Notification Icons');
      final androidNotificationImageFile =
          File('$source/${config.androidConfig.notificationImage}')
              .readAsBytesSync();
      final androidNotificationImage =
          decodeImage(androidNotificationImageFile);

      for (final size in _androidNotificationIconSizes.entries) {
        final destPath =
            '$destination/android/app/src/main/res/drawable-${size.key}';
        final dir = await Directory(destPath);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        final resized = copyResize(androidNotificationImage,
            width: (size.value).toInt(), height: (size.value).toInt());
        File('$destPath/ic_stat_onesignal_default.png')
            .writeAsBytesSync(encodePng(resized));
      }
    }
  }
}
