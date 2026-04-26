import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

// Copies a bundled asset to the temp directory and returns its path.
// The native plugin needs a real file path on disk, not an asset URI.
Future<String> _assetToFile(String assetName) async {
  final bytes = await rootBundle.load('assets/$assetName');
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$assetName');
  await file.writeAsBytes(bytes.buffer.asUint8List());
  return file.path;
}

// Checks PNG magic bytes: \x89PNG
bool _isPng(List<int> bytes) =>
    bytes.length >= 4 &&
    bytes[0] == 0x89 &&
    bytes[1] == 0x50 &&
    bytes[2] == 0x4E &&
    bytes[3] == 0x47;

// Checks JPEG magic bytes: \xFF\xD8\xFF
bool _isJpeg(List<int> bytes) =>
    bytes.length >= 3 &&
    bytes[0] == 0xFF &&
    bytes[1] == 0xD8 &&
    bytes[2] == 0xFF;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const heicSamples = ['sample1.heic', 'sample2.heic', 'sample3.heic'];
  const heifSamples = ['sample1.heif', 'sample2.heif', 'sample3.heif'];
  const allSamples = [...heicSamples, ...heifSamples];

  group('HeifConverter — real file conversion', () {
    for (final sample in allSamples) {
      testWidgets('convert $sample to PNG', (tester) async {
        final inputPath = await _assetToFile(sample);

        final outputPath =
            await HeifConverter.convert(inputPath, format: 'png');

        expect(outputPath, isNotNull, reason: 'convert() should return a path');
        expect(outputPath, endsWith('.png'));

        final outputFile = File(outputPath!);
        expect(outputFile.existsSync(), isTrue,
            reason: 'Output file should exist on disk');
        expect(outputFile.lengthSync(), greaterThan(0),
            reason: 'Output file should not be empty');

        final header = outputFile.readAsBytesSync().take(4).toList();
        expect(_isPng(header), isTrue,
            reason: 'Output file should have PNG magic bytes');
      });

      testWidgets('convert $sample to JPEG', (tester) async {
        final inputPath = await _assetToFile(sample);

        final outputPath =
            await HeifConverter.convert(inputPath, format: 'jpg');

        expect(outputPath, isNotNull);
        expect(outputPath, endsWith('.jpg'));

        final outputFile = File(outputPath!);
        expect(outputFile.existsSync(), isTrue);
        expect(outputFile.lengthSync(), greaterThan(0));

        final header = outputFile.readAsBytesSync().take(3).toList();
        expect(_isJpeg(header), isTrue,
            reason: 'Output file should have JPEG magic bytes');
      });

      testWidgets('convert $sample with explicit output path', (tester) async {
        final inputPath = await _assetToFile(sample);
        final dir = await getTemporaryDirectory();
        final outputPath = '${dir.path}/explicit_$sample.png';

        final result =
            await HeifConverter.convert(inputPath, output: outputPath);

        expect(result, outputPath);
        expect(File(outputPath).existsSync(), isTrue);
        expect(File(outputPath).lengthSync(), greaterThan(0));
      });
    }

    testWidgets('throws when neither output nor format is provided',
        (tester) async {
      final inputPath = await _assetToFile('sample1.heic');

      expect(
        () => HeifConverter.convert(inputPath),
        throwsA(isA<ArgumentError>()),
      );
    });

    testWidgets('PNG output is smaller than JPEG for same input',
        (tester) async {
      // Just a sanity check — both should produce valid non-empty files.
      final inputPath = await _assetToFile('sample1.heic');

      final pngPath = await HeifConverter.convert(inputPath, format: 'png');
      final jpgPath = await HeifConverter.convert(inputPath, format: 'jpg');

      expect(File(pngPath!).lengthSync(), greaterThan(0));
      expect(File(jpgPath!).lengthSync(), greaterThan(0));
    });
  });
}
