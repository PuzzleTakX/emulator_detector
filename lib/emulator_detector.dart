
import 'emulator_detector_platform_interface.dart';

class EmulatorDetector {
  Future<String?> getPlatformVersion() {
    return EmulatorDetectorPlatform.instance.getPlatformVersion();
  }
}
