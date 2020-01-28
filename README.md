# Tango
Tango is a flexible build configuration tool that is the perfect partner for your Flutter project. Setup different build variants like paid/free or development/production. Tango handles copying of files, scaling images for different screen resolutions. It makes it super easy to swap out app icons for different build or provide different provisioning files for various distributions.

Tango is 100% written in Dart and should be easy to extend for your needs.

## Install

pub global activate tango

## Quick Start
This creates and runs a new Flutter project with example build configurations.
* Requires Flutter and Tango installed

```
flutter create tango_quick_start
cd tango_quick_start
tango --quickstart
tango quick
flutter run
```

## Getting Started

In your flutter project create json configuration file that tango operate on. The current features are

Copy and Scale:
* copied - Map of destination location to source location. Path relative to source and destination folder
* scaledImages - Map of destination location to source location. Path relative to source and destination folder

Platform assets: (Path to image relative to source folder) 
* iosConfig
  * iconImage 
  * launchImage
* androidConfig
  * iconImage
  * launchImage
  * notificationImage
* macConfig
  * iconImage

### Example
For organizational purposes it is helpful to place your tango variants into a subfolder in you flutter project.

```
Flutter_Project
 -tango
  -MyApp
   -images
    my_app_image.png
   -lib
    my_app_constants.dart
   -my_app.json
  -YourApp
   -images
    your_app_image.png
   -lib
    your_app_constants.dart
   -your_app.json
```


```javascript
{
    "copied": {
        "lib/constants.dart":"files/file1.dart",
        "lib/theme.dart":"files/file2.dart"
    },
    "scaledImages": {
        "assets/logo.jpg":"images/tango.png"
    },
    "iosConfig": {
        "launchImage": "images/tango_launch.png",
        "iconImage": "images/tango_icon.png"
    },
    "androidConfig": {
        "launchImage": "images/tango_launch.png",
        "iconImage": "images/tango_icon.png",
        "notificationImage": "images/tango_notification.png"
    }
}
```


## Usage

In your flutter project
```
>tango -s <source_path> <config_name.json>
```

There are many ways you can setup your project to take advantage of tango. For example:
```
>tango -s ./variants/halloween_theme base_app.json free_app.json dev_options.json
>tango -s ./variants/chistmas_theme base_app.json paid_app prod_options.json
```

## Add Tango Yaml

To simplyfy the command line tango can take a yaml file as imput to point it to the source and config files.
Take a look at the example. Now the build variants can be setup in the tango.yaml file and the input is the build variant. 

```
>tango free_app
>tango paid_app
```
