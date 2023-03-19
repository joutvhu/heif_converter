
import 'heif_converter_platform_interface.dart';

class HeifConverter {
  Future<String?> getPlatformVersion() {
    return HeifConverterPlatform.instance.getPlatformVersion();
  }
}
