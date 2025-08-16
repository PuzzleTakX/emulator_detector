import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'emulator_detector_method_channel.dart';

abstract class EmulatorDetectorPlatform extends PlatformInterface {
  /// Constructs a EmulatorDetectorPlatform.
  EmulatorDetectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static EmulatorDetectorPlatform _instance = MethodChannelEmulatorDetector();

  /// The default instance of [EmulatorDetectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelEmulatorDetector].
  static EmulatorDetectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EmulatorDetectorPlatform] when
  /// they register themselves.
  static set instance(EmulatorDetectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
