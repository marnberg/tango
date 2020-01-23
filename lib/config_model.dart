const Map<String, double> _defaultScales = {
  '/4.0x/': 1,
  '/3.0x/': 0.6667,
  '/2.0x/': 0.50,
  '/': 0.3334
};

class PlatformConfig {
  final String launchImage;
  final String iconImage;

  PlatformConfig({this.iconImage, this.launchImage});

  PlatformConfig.fromJson(Map json)
      : launchImage = json['launchImage'],
        iconImage = json['iconImage'];
}

class IosConfig extends PlatformConfig {
  IosConfig({String iconImage, String launchImage})
      : super(iconImage: iconImage, launchImage: launchImage);

  factory IosConfig.fromJson(Map json) => IosConfig(
        iconImage: json['iconImage'],
        launchImage: json['launchImage'],
      );

  IosConfig merge(IosConfig config) {
    return IosConfig(
      iconImage: config.iconImage ?? iconImage,
      launchImage: config.launchImage ?? launchImage,
    );
  }
}

class AndroidConfig extends PlatformConfig {
  final String notificationImage;
  AndroidConfig({String iconImage, String launchImage, this.notificationImage})
      : super(iconImage: iconImage, launchImage: launchImage);

  factory AndroidConfig.fromJson(Map json) => AndroidConfig(
      iconImage: json['iconImage'],
      launchImage: json['launchImage'],
      notificationImage: json['notificationImage']);

  AndroidConfig merge(AndroidConfig config) {
    return AndroidConfig(
      iconImage: config.iconImage ?? iconImage,
      launchImage: config.launchImage ?? launchImage,
      notificationImage: config.notificationImage ?? notificationImage,
    );
  }
}

class TangoConfig {
  final Map<String, String> copied;
  final Map<String, String> scaledImages;
  final Map<String, double> scalesMap;

  final IosConfig iosConfig;
  final AndroidConfig androidConfig;

  TangoConfig(
      {this.copied = const {},
      this.scaledImages = const {},
      this.iosConfig,
      this.androidConfig,
      this.scalesMap = _defaultScales});

  TangoConfig.fromJson(Map json)
      : copied = Map<String, String>.from(json['copied']),
        scaledImages = Map<String, String>.from(json['scaledImages']),
        scalesMap = json['imageScales'] != null
            ? Map<String, double>.from(json['imageScales'])
            : _defaultScales,
        iosConfig = json['iosConfig'] != null
            ? IosConfig.fromJson(json['iosConfig'])
            : null,
        androidConfig = json['androidConfig'] != null
            ? AndroidConfig.fromJson(json['androidConfig'])
            : null;

  TangoConfig merge(TangoConfig config) {
    return TangoConfig(
        copied: {...copied, ...config.copied},
        scaledImages: {...scaledImages, ...config.scaledImages},
        iosConfig:
            config.iosConfig?.merge(config.iosConfig) ?? config.iosConfig,
        androidConfig: config.androidConfig?.merge(config.androidConfig) ??
            config.androidConfig);
  }
}
