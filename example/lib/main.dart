import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEIF Converter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ConvertPage(),
    );
  }
}

// All bundled sample files.
const _samples = [
  'sample1.heic',
  'sample2.heic',
  'sample3.heic',
  'sample1.heif',
  'sample2.heif',
  'sample3.heif',
];

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  String _selectedSample = _samples.first;
  String _selectedFormat = 'png';
  _ConvertState _state = _ConvertState.idle;
  String? _outputPath;
  String? _errorMessage;

  Future<void> _convert() async {
    setState(() {
      _state = _ConvertState.loading;
      _outputPath = null;
      _errorMessage = null;
    });

    try {
      final inputPath = await _assetToFile(_selectedSample);
      final result = await HeifConverter.convert(
        inputPath,
        format: _selectedFormat,
      );
      setState(() {
        _outputPath = result;
        _state = _ConvertState.success;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _state = _ConvertState.error;
      });
    }
  }

  /// Copies a bundled asset to the temp directory so the native plugin can
  /// access it via a real file path.
  Future<String> _assetToFile(String assetName) async {
    final bytes = await rootBundle.load('assets/$assetName');
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$assetName');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HEIF Converter Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sample file picker
            DropdownButtonFormField<String>(
              initialValue: _selectedSample,
              decoration: const InputDecoration(
                labelText: 'Sample file',
                border: OutlineInputBorder(),
              ),
              items: _samples
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedSample = v!),
            ),
            const SizedBox(height: 12),
            // Format selector
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'png', label: Text('PNG'), icon: Icon(Icons.image)),
                ButtonSegment(
                    value: 'jpg', label: Text('JPEG'), icon: Icon(Icons.photo)),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (s) =>
                  setState(() => _selectedFormat = s.first),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _state == _ConvertState.loading ? null : _convert,
              icon: const Icon(Icons.transform),
              label: const Text('Convert'),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildResult()),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    switch (_state) {
      case _ConvertState.idle:
        return const Center(
          child: Text(
            'Select a sample file and tap Convert.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      case _ConvertState.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Converting…'),
            ],
          ),
        );
      case _ConvertState.error:
        return Center(
          child: Text(
            'Error: $_errorMessage',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        );
      case _ConvertState.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Output: $_outputPath',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _outputPath != null
                  ? Image.file(File(_outputPath!), fit: BoxFit.contain)
                  : const Center(child: Text('No output file')),
            ),
          ],
        );
    }
  }
}

enum _ConvertState { idle, loading, error, success }
