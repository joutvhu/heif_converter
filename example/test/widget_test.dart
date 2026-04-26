import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heif_converter_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('heif_converter');

  setUp(() {
    // Mock asset loading for sample files
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'convert') {
        final args = call.arguments as Map;
        final output = args['output'] as String?;
        final format = args['format'] as String?;
        if (output != null) return output;
        if (format != null) return '/tmp/converted.$format';
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('renders sample dropdown and format selector', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.text('PNG'), findsOneWidget);
    expect(find.text('JPEG'), findsOneWidget);
    expect(find.text('Convert'), findsOneWidget);
  });

  testWidgets('shows idle message on start', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Select a sample file and tap Convert.'), findsOneWidget);
  });

  testWidgets('first sample is selected by default', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('sample1.heic'), findsOneWidget);
  });

  testWidgets('PNG is selected by default', (tester) async {
    await tester.pumpWidget(const MyApp());

    final button = tester.widget<SegmentedButton<String>>(
      find.byType(SegmentedButton<String>),
    );
    expect(button.selected, {'png'});
  });

  testWidgets('can switch to JPEG format', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('JPEG'));
    await tester.pump();

    final button = tester.widget<SegmentedButton<String>>(
      find.byType(SegmentedButton<String>),
    );
    expect(button.selected, {'jpg'});
  });

  testWidgets('shows loading indicator while converting', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Convert'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Converting…'), findsOneWidget);
  });

  testWidgets('convert button is disabled while loading', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Convert'));
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Convert'),
    );
    expect(button.onPressed, isNull);
  });
}
