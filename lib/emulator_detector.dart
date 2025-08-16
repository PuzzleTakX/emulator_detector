
import 'emulator_detector_platform_interface.dart';

class EmulatorDetector {
  Future<String?> getPlatformVersion() {
    return EmulatorDetectorPlatform.instance.getPlatformVersion();
  }
  Future<Map<String, dynamic>> get getEmulatorChecks async {
    final checks = await EmulatorDetectorPlatform.instance.getEmulatorChecks;
    return checks;
  }
  Future<bool> get isEmulator async {
    try {
      final result = await EmulatorDetectorPlatform.instance.isEmulator;
      return result;
    } catch (e) {
      return true;
    }
  }
}
