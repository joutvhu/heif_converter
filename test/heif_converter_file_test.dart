import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:heif_converter/heif_converter_platform_interface.dart';
import 'package:heif_converter/heif_converter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Mock platform that simulates a real conversion by echoing back the expected
// output path, mirroring what the native side would return.
class _FakePlatform
    with MockPlatformInterfaceMixin
    implements HeifConverterPlatform {
  @override
  Future<String?> convert(String path, {String? output, String? format}) {
    if (output != null) return Future.value(output);
    if (format != null) {
      final base =
          path.replaceAll(RegExp(r'\.(heic|heif)$', caseSensitive: false), '');
      return Future.value('$base.$format');
    }
    return Future.value(null);
  }
}

// Resolves a path under the test/ directory.
// Flutter test runner sets the working directory to the project root,
// so we simply prepend 'test/'.
String _samplePath(String filename) => 'test/$filename';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ── Unit tests using mock platform ──────────────────────────────────────────
  group('with mock platform and real file paths', () {
    setUp(() {
      HeifConverterPlatform.instance = _FakePlatform();
    });

    // HEIC files
    for (final filename in ['sample1.heic', 'sample2.heic', 'sample3.heic']) {
      test('$filename exists on disk', () {
        final file = File(_samplePath(filename));
        expect(file.existsSync(), isTrue,
            reason: '${file.path} should exist in test/');
      });

      test('$filename has non-zero size', () {
        final file = File(_samplePath(filename));
        expect(file.lengthSync(), greaterThan(0));
      });

      test('convert $filename to PNG returns .png path', () async {
        final path = _samplePath(filename);
        final result = await HeifConverter.convert(path, format: 'png');
        expect(result, isNotNull);
        expect(result, endsWith('.png'));
      });

      test('convert $filename to JPEG returns .jpg path', () async {
        final path = _samplePath(filename);
        final result = await HeifConverter.convert(path, format: 'jpg');
        expect(result, isNotNull);
        expect(result, endsWith('.jpg'));
      });

      test('convert $filename with explicit output path', () async {
        final path = _samplePath(filename);
        final output = _samplePath('output_$filename.png');
        final result = await HeifConverter.convert(path, output: output);
        expect(result, output);
      });
    }

    // HEIF files
    for (final filename in ['sample1.heif', 'sample2.heif', 'sample3.heif']) {
      test('$filename exists on disk', () {
        final file = File(_samplePath(filename));
        expect(file.existsSync(), isTrue,
            reason: '${file.path} should exist in test/');
      });

      test('$filename has non-zero size', () {
        final file = File(_samplePath(filename));
        expect(file.lengthSync(), greaterThan(0));
      });

      test('convert $filename to PNG returns .png path', () async {
        final path = _samplePath(filename);
        final result = await HeifConverter.convert(path, format: 'png');
        expect(result, isNotNull);
        expect(result, endsWith('.png'));
      });

      test('convert $filename to JPEG returns .jpg path', () async {
        final path = _samplePath(filename);
        final result = await HeifConverter.convert(path, format: 'jpg');
        expect(result, isNotNull);
        expect(result, endsWith('.jpg'));
      });
    }
  });

  // ── Method channel tests with real file paths ────────────────────────────────
  group('method channel with real file paths', () {
    late MethodChannelHeifConverter platform;
    const MethodChannel channel = MethodChannel('heif_converter');

    setUp(() {
      platform = MethodChannelHeifConverter();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method != 'convert') return null;
        final args = call.arguments as Map;
        final path = args['path'] as String;
        final output = args['output'] as String?;
        final format = args['format'] as String?;
        if (output != null && output.isNotEmpty) return output;
        if (format != null && format.isNotEmpty) {
          final base = path.replaceAll(
              RegExp(r'\.(heic|heif)$', caseSensitive: false), '');
          return '$base.$format';
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    for (final filename in [
      'sample1.heic',
      'sample2.heic',
      'sample3.heic',
      'sample1.heif',
      'sample2.heif',
      'sample3.heif',
    ]) {
      test('channel receives correct path for $filename', () async {
        MethodCall? captured;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall call) async {
          captured = call;
          return 'output.png';
        });

        final path = _samplePath(filename);
        await platform.convert(path, format: 'png');

        expect(captured, isNotNull);
        final args = captured!.arguments as Map;
        expect(args['path'], path);
        expect(args['format'], 'png');
      });
    }

    test('throws ArgumentError for real file path without output or format',
        () {
      final path = _samplePath('sample1.heic');
      expect(
        () => platform.convert(path),
        throwsA(isA<ArgumentError>().having((e) => e.name, 'name', 'output')),
      );
    });
  });
}
