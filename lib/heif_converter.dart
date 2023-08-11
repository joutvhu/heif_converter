import 'heif_converter_platform_interface.dart';

class HeifConverter {
  static Future<String?> convert(
    String path, {
    String? output,
    String? format,
  }) {
    return HeifConverterPlatform.instance.convert(path, output: output, format: format);
  }
}
