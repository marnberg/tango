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

const Map<String, double> _defaultScales = {
  '/4.0x/': 1,
  '/3.0x/': 0.6667,
  '/2.0x/': 0.50,
  '/': 0.3334
};

class PlatformConfig {
  final String iconImage;

  PlatformConfig({this.iconImage});

  PlatformConfig.fromJson(Map json) : iconImage = json['iconImage'];
}

class IosConfig extends PlatformConfig {
  final String launchImage;

  IosConfig({String iconImage, this.launchImage}) : super(iconImage: iconImage);

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

class MacConfig extends PlatformConfig {
  MacConfig({String iconImage}) : super(iconImage: iconImage);

  factory MacConfig.fromJson(Map json) => MacConfig(
        iconImage: json['iconImage'],
      );

  IosConfig merge(IosConfig config) {
    return IosConfig(
      iconImage: config.iconImage ?? iconImage,
    );
  }
}

class AndroidConfig extends PlatformConfig {
  final String launchImage;

  final String notificationImage;
  AndroidConfig({String iconImage, this.launchImage, this.notificationImage})
      : super(iconImage: iconImage);

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
  final IosConfig macConfig;

  final AndroidConfig androidConfig;

  TangoConfig(
      {this.copied = const {},
      this.scaledImages = const {},
      this.iosConfig,
      this.macConfig,
      this.androidConfig,
      this.scalesMap = _defaultScales});

  TangoConfig.fromJson(Map json)
      : copied = json['copied'] != null
            ? Map<String, String>.from(json['copied'])
            : null,
        scaledImages = json['scaledImages'] != null
            ? Map<String, String>.from(json['scaledImages'])
            : null,
        scalesMap = json['imageScales'] != null
            ? Map<String, double>.from(json['imageScales'])
            : _defaultScales,
        iosConfig = json['iosConfig'] != null
            ? IosConfig.fromJson(json['iosConfig'])
            : null,
        macConfig = json['macConfig'] != null
            ? IosConfig.fromJson(json['macConfig'])
            : null,
        androidConfig = json['androidConfig'] != null
            ? AndroidConfig.fromJson(json['androidConfig'])
            : null;

  TangoConfig merge(TangoConfig config) {
    return TangoConfig(
        copied: config.copied != null ? {...copied, ...config.copied} : copied,
        scaledImages: config.scaledImages != null
            ? {...scaledImages, ...config.scaledImages}
            : scaledImages,
        iosConfig:
            config.iosConfig?.merge(config.iosConfig) ?? config.iosConfig,
        macConfig:
            config.macConfig?.merge(config.macConfig) ?? config.macConfig,
        androidConfig: config.androidConfig?.merge(config.androidConfig) ??
            config.androidConfig);
  }
}
