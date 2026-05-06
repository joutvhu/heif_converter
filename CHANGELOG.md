## [Unreleased]

* Add Swift Package Manager (SPM) support for iOS alongside the existing CocoaPods integration

## 1.0.2

* Fix crash on iOS caused by incorrect output path format string (`%d.%s` → `%d.%@`)
* Fix iOS always returning nil by using `UIImage(contentsOfFile:)` instead of `UIImage(named:)`
* Fix iOS force cast crash — use `guard let` with safe cast instead of `as!`
* Fix iOS silent nil return on conversion failure — now returns `FlutterError` with `conversionFailed` code
* Fix iOS output path failing when parent directories do not exist
* Fix Android `FileOutputStream` resource leak using try-with-resources
* Fix Android `NullPointerException` when `BitmapFactory.decodeFile` returns null
* Fix Android output path failing when parent directories do not exist
* Fix Android `Bitmap` memory leak — call `recycle()` after compression
* Update Android `compileSdkVersion` to 34
* Update Android Gradle plugin to 8.2.2 and Gradle wrapper to 8.4 for Java 21 compatibility
* Update Android `version` in build.gradle to match pubspec
* Migrate example Android build scripts to declarative Flutter Gradle plugin
* Update example app to use bundled sample HEIC/HEIF files instead of downloading
* Update Flutter SDK constraint to `>=3.0.0`
* Fix podspec description placeholder text
* Bump `flutter_lints` to 5.0.0

## 1.0.1

* Add android namespace

## 1.0.0

* Initial release.
