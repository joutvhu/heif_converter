import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelHeifConverter platform;
  const MethodChannel channel = MethodChannel('heif_converter');

  setUp(() {
    platform = MethodChannelHeifConverter();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'convert') {
        final args = call.arguments as Map;
        final output = args['output'] as String?;
        final format = args['format'] as String?;
        if (output != null && output.isNotEmpty) return output;
        if (format != null && format.isNotEmpty) {
          return '/tmp/converted.$format';
        }
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('MethodChannelHeifConverter.convert', () {
    test('returns output path when output is provided', () async {
      final result = await platform.convert('image.heic', output: 'image.png');
      expect(result, 'image.png');
    });

    test('returns generated path when format is provided', () async {
      final result = await platform.convert('image.heic', format: 'png');
      expect(result, '/tmp/converted.png');
    });

    test('returns generated jpeg path when format is jpg', () async {
      final result = await platform.convert('image.heic', format: 'jpg');
      expect(result, '/tmp/converted.jpg');
    });

    test('throws ArgumentError when neither output nor format is provided',
        () async {
      expect(
        () => platform.convert('image.heic'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.name,
          'argument name',
          'output',
        )),
      );
    });

    test('sends correct arguments to method channel', () async {
      MethodCall? captured;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        captured = call;
        return 'result.png';
      });

      await platform.convert('photo.heic', output: 'result.png', format: 'png');

      expect(captured, isNotNull);
      expect(captured!.method, 'convert');
      final args = captured!.arguments as Map;
      expect(args['path'], 'photo.heic');
      expect(args['output'], 'result.png');
      expect(args['format'], 'png');
    });

    test('sends null output when only format is provided', () async {
      MethodCall? captured;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        captured = call;
        return '/tmp/converted.jpg';
      });

      await platform.convert('photo.heic', format: 'jpg');

      final args = captured!.arguments as Map;
      expect(args['output'], isNull);
      expect(args['format'], 'jpg');
    });
  });
}
