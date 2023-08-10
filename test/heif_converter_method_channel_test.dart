import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter/heif_converter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelHeifConverter platform = MethodChannelHeifConverter();
  const MethodChannel channel = MethodChannel('heif_converter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return 'image.png';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('convert', () async {
    expect(await platform.convert('image.heic', 'image.png'), 'image.png');
  });
}
