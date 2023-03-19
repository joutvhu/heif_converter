
import 'heif_converter_platform_interface.dart';

class HeifConverter {
  Future<String?> convert(String path, String output) {
    return HeifConverterPlatform.instance.convert(path, output);
  }
}
