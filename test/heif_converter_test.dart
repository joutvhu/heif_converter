import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:heif_converter/heif_converter_platform_interface.dart';
import 'package:heif_converter/heif_converter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHeifConverterPlatform
    with MockPlatformInterfaceMixin
    implements HeifConverterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HeifConverterPlatform initialPlatform = HeifConverterPlatform.instance;

  test('$MethodChannelHeifConverter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHeifConverter>());
  });

  test('getPlatformVersion', () async {
    HeifConverter heifConverterPlugin = HeifConverter();
    MockHeifConverterPlatform fakePlatform = MockHeifConverterPlatform();
    HeifConverterPlatform.instance = fakePlatform;

    expect(await heifConverterPlugin.getPlatformVersion(), '42');
  });
}
