# HEIF Converter

[![pub package](https://img.shields.io/pub/v/heif_converter.svg)](https://pub.dev/packages/heif_converter)

Flutter plugin to convert HEIC/HEIF image files to PNG or JPEG format on Android and iOS.

## Platform Support

| Android | iOS |
|:-------:|:---:|
| ✅      | ✅  |

## Requirements

- Flutter `>=3.0.0`
- Android `minSdk 16`
- iOS `11.0`

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  heif_converter: ^1.0.2
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:heif_converter/heif_converter.dart';
```

### Convert to JPEG

```dart
final String? outputPath = await HeifConverter.convert(
  '/path/to/image.heic',
  format: 'jpg',
);
```

### Convert to PNG

```dart
final String? outputPath = await HeifConverter.convert(
  '/path/to/image.heic',
  format: 'png',
);
```

### Convert with explicit output path

```dart
final String? outputPath = await HeifConverter.convert(
  '/path/to/image.heic',
  output: '/path/to/output.png',
);
```

## API

### `HeifConverter.convert`

```dart
static Future<String?> convert(
  String path, {
  String? output,
  String? format,
})
```

| Parameter | Type     | Description |
|-----------|----------|-------------|
| `path`    | `String` | Path to the input HEIC/HEIF file on disk. |
| `output`  | `String?` | Full path for the output file. Takes precedence over `format` if both are provided. |
| `format`  | `String?` | Output format: `'png'` or `'jpg'`. Used to auto-generate an output path in the system temp directory. |

**Returns** the output file path on success, or `null` if conversion fails.

**Throws** `ArgumentError` if neither `output` nor `format` is provided.

## Error Handling

The native side returns a `PlatformException` in the following cases:

| Code | Description |
|------|-------------|
| `illegalArgument` | Input path is blank, or neither output path nor format was provided. |
| `conversionFailed` | The image could not be decoded or encoded (corrupt file, unsupported format, etc.). |

```dart
try {
  final outputPath = await HeifConverter.convert(heicPath, format: 'png');
  if (outputPath != null) {
    // use outputPath
  }
} on ArgumentError catch (e) {
  // missing output and format
} on PlatformException catch (e) {
  // native conversion error — e.code, e.message
}
```

## License

[MIT](LICENSE)
