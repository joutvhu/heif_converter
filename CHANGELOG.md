## 1.0.0

* Initial release.

## 1.0.1

* Add android namespace

## 1.0.2

* Fix crash on iOS caused by incorrect output path format string (`%d.%s` → `%d.%@`)
* Fix iOS always returning nil by using `UIImage(contentsOfFile:)` instead of `UIImage(named:)`
* Fix Android `FileOutputStream` resource leak using try-with-resources
* Fix Android `NullPointerException` when `BitmapFactory.decodeFile` returns null
* Update Android `compileSdkVersion` to 34
* Bump `flutter_lints` to 5.0.0
