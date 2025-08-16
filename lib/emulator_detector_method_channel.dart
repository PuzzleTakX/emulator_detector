import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'emulator_detector_platform_interface.dart';

/// An implementation of [EmulatorDetectorPlatform] that uses method channels.
class MethodChannelEmulatorDetector extends EmulatorDetectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('emulator_detector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
