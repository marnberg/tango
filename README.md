# tango
Flutter build configuration tool to inject icons, launch images, files, code and more.

## Install

pub global activete tango

## Getting Started

In your flutter project create tango json configuration file.

The basic values in the configuration file are:
*copied - Map of desitination location to source location
*scaledImages - Map of desitination location to source location, supported formats 'png, jpeg'

Icon and launch image configurations:
*iosConfig
⋅⋅*iconImage
⋅⋅*launchImage
*androidConfig
⋅⋅*iconImage
⋅⋅*launchImage
*macConfig
⋅⋅*iconImage


##Usage

In your flutter project
```
>tango -s <source_path> <config_name.json>
```

There are many ways you can setup your project to take advantage of tango. For example:
```
>tango -s ./variants/halloween_theme base_app.json free_app.json dev_options.json
>tango -s ./variants/chistmas_theme base_app.json paid_app prod_options.json
```








