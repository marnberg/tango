import 'dart:io';

import 'package:image/image.dart';

void quick_start({String destination = '.', bool force = false}) {
  print('Initializing Tango in path "$destination"');
  if (!force && !(File('$destination/pubspec.yaml').existsSync())) {
    exitCode = -1;
    stderr
        .writeln('Initialization folder does not look like a flutter project.');
    return;
  }
  final gitignore = File('$destination/.gitignore');
  if (!gitignore.existsSync()) {
    gitignore.createSync();
  }
  final ignore = gitignore.readAsStringSync();
  if (ignore.contains('# Tango ignore')) {
    print(
        'Skipping modifying git ignore, since it looks like it is has tango components');
  } else {
    print('Appending Tango git ignore');
    gitignore.writeAsStringSync(
        '$ignore\n\n# Tango ignore\nlib/constants.dart\nassets/generated\nios/Runner/Assets.xcassets/AppIcon.appiconset/*.png \nios/Runner/Assets.xcassets/LaunchImage.imageset/*.png\nmacos/Runner/Assets.xcassets/AppIcon.appiconset/*.png \nandroid/app/src/main/res/*/ic_stat_onesignal_default.png\nandroid/app/src/main/res/*/ic_launcher.png\nandroid/app/src/main/res/*/launch_image.png\nandroid/app/src/main/res/drawable/launch_background.xml\n');
  }

  final yaml = File('$destination/tango.yaml');
  if (yaml.existsSync()) {
    print('Skipping inserting tango.yaml, since it already exists');
  } else {
    print('Adding tango.yaml');

    yaml.writeAsStringSync(
        '\nquick:\n  source: tango/quick\n  config:\n    - base.json\n');
  }

  print('Adding tango/quick resources');

  final configPath = '$destination/tango/quick/';
  final config = File('$configPath/base.json');
  config.createSync(recursive: true);
  config.writeAsStringSync(
      '{\n    "copied": {\n        "lib/constants.dart": "lib/constants.dart"\n    },\n    "scaledImages": {\n        "assets/logo.jpg": "images/logo.png"\n    },\n    "iosConfig": {\n        "launchImage": "images/logo.png",\n        "iconImage": "images/icon.png"\n    },\n    "androidConfig": {\n        "launchImage": "images/logo.png",\n        "iconImage": "images/icon.png",\n        "notificationImage": "images/notification_logo.png"\n    }\n}');

  final imagePath = '$destination/tango/quick/images';
  final imageDir = Directory(imagePath);
  imageDir.createSync(recursive: true);

  final icon = Image(1024, 1024);
  _fillImage(icon, arial_48);
  File('$imagePath/icon.png').writeAsBytesSync(encodePng(icon));

  final logo = Image(300, 200);
  _fillImage(logo, arial_48);
  File('$imagePath/logo.png').writeAsBytesSync(encodePng(logo));

  final notificationLogo = Image(96, 96);
  _fillImage(notificationLogo, arial_14);

  File('$imagePath/notification_logo.png')
      .writeAsBytesSync(encodePng(notificationLogo));

  final codePath = '$destination/tango/quick/lib';
  final constants = File('$codePath/constants.dart');
  constants.createSync(recursive: true);
  constants.writeAsStringSync(
      '\nclass AppConstants  {\n  String get title => \'Quick Start\';\n}\n');

  print('\n\nTo inject the "quick configuration" run');
  print('>tango quick');
  print('Then run Flutter:');
  print('>flutter run\n');

  print('Then try editing tango.yaml and content in tango/quick folder. Run "tango quick" after edit.\n');
}

void _fillImage(Image image, BitmapFont font) {
  fill(image, getColor(255, 255, 255));

  // Draw some text using 24pt arial font

  drawString(image, font, image.width ~/ 10, image.height ~/ 10, 'Tango',
      color: getColor(0, 0, 0));
}
