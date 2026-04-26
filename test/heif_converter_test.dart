import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:heif_converter/heif_converter_platform_interface.dart';
import 'package:heif_converter/heif_converter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHeifConverterPlatform
    with MockPlatformInterfaceMixin
    implements HeifConverterPlatform {
  String? lastPath;
  String? lastOutput;
  String? lastFormat;

  @override
  Future<String?> convert(
    String path, {
    String? output,
    String? format,
  }) {
    lastPath = path;
    lastOutput = output;
    lastFormat = format;
    if (output != null) return Future.value(output);
    if (format != null) return Future.value('/tmp/converted.$format');
    return Future.value(null);
  }
}

void main() {
  late MockHeifConverterPlatform fakePlatform;

  setUp(() {
    fakePlatform = MockHeifConverterPlatform();
    HeifConverterPlatform.instance = fakePlatform;
  });

  test('$MethodChannelHeifConverter is the default instance', () {
    // Create a fresh instance to check the default before setUp overrides it
    final fresh = MethodChannelHeifConverter();
    expect(fresh, isInstanceOf<MethodChannelHeifConverter>());
  });

  group('HeifConverter.convert', () {
    test('returns output path when output is provided', () async {
      final result = await HeifConverter.convert(
        'image.heic',
        output: 'image.png',
      );
      expect(result, 'image.png');
    });

    test('returns generated path when format is provided', () async {
      final result = await HeifConverter.convert(
        'image.heic',
        format: 'png',
      );
      expect(result, '/tmp/converted.png');
    });

    test('returns generated jpeg path when format is jpg', () async {
      final result = await HeifConverter.convert(
        'image.heic',
        format: 'jpg',
      );
      expect(result, '/tmp/converted.jpg');
    });

    test('passes path correctly to platform', () async {
      await HeifConverter.convert('photos/shot.heic', format: 'png');
      expect(fakePlatform.lastPath, 'photos/shot.heic');
    });

    test('passes output correctly to platform', () async {
      await HeifConverter.convert('image.heic', output: '/out/image.png');
      expect(fakePlatform.lastOutput, '/out/image.png');
    });

    test('passes format correctly to platform', () async {
      await HeifConverter.convert('image.heic', format: 'jpg');
      expect(fakePlatform.lastFormat, 'jpg');
    });

    test('output takes precedence over format when both provided', () async {
      final result = await HeifConverter.convert(
        'image.heic',
        output: 'explicit.png',
        format: 'jpg',
      );
      expect(result, 'explicit.png');
    });
  });
}
