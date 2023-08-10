import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:heif_converter/heif_converter_platform_interface.dart';
import 'package:heif_converter/heif_converter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHeifConverterPlatform
    with MockPlatformInterfaceMixin
    implements HeifConverterPlatform {

  @override
  Future<String?> convert(String path, {
    String? output,
    String? format,
  }) => Future.value(output);
}

void main() {
  final HeifConverterPlatform initialPlatform = HeifConverterPlatform.instance;

  test('$MethodChannelHeifConverter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHeifConverter>());
  });

  test('convert', () async {
    HeifConverter heifConverterPlugin = HeifConverter();
    MockHeifConverterPlatform fakePlatform = MockHeifConverterPlatform();
    HeifConverterPlatform.instance = fakePlatform;

    expect(await heifConverterPlugin.convert('image.heic', output: 'image.png'), 'image.png');
  });
}
