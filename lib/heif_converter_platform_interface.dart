import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'heif_converter_method_channel.dart';

abstract class HeifConverterPlatform extends PlatformInterface {
  /// Constructs a HeifConverterPlatform.
  HeifConverterPlatform() : super(token: _token);

  static final Object _token = Object();

  static HeifConverterPlatform _instance = MethodChannelHeifConverter();

  /// The default instance of [HeifConverterPlatform] to use.
  ///
  /// Defaults to [MethodChannelHeifConverter].
  static HeifConverterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HeifConverterPlatform] when
  /// they register themselves.
  static set instance(HeifConverterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
