import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'heif_converter_platform_interface.dart';

/// An implementation of [HeifConverterPlatform] that uses method channels.
class MethodChannelHeifConverter extends HeifConverterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('heif_converter');

  @override
  Future<String?> convert(String path, {
    String? output,
    String? format,
  }) async {
    if (output == null && format == null) {
      throw ArgumentError('Please provide output path or format for conversion.','output');
    }
    final result = await methodChannel
        .invokeMethod<String>('convert', {'path': path, 'output': output, 'format': format});
    return result;
  }
}
