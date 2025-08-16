import 'package:flutter_test/flutter_test.dart';
import 'package:emulator_detector/emulator_detector.dart';
import 'package:emulator_detector/emulator_detector_platform_interface.dart';
import 'package:emulator_detector/emulator_detector_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEmulatorDetectorPlatform
    with MockPlatformInterfaceMixin
    implements EmulatorDetectorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> get isEmulator => Future.value(false);

  @override
  Future<Map<String, dynamic>> get getEmulatorChecks => Future.value({});

}

void main() {
  final EmulatorDetectorPlatform initialPlatform = EmulatorDetectorPlatform.instance;

  test('$MethodChannelEmulatorDetector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEmulatorDetector>());
  });

  test('getPlatformVersion', () async {
    EmulatorDetector emulatorDetectorPlugin = EmulatorDetector();
    MockEmulatorDetectorPlatform fakePlatform = MockEmulatorDetectorPlatform();
    EmulatorDetectorPlatform.instance = fakePlatform;

    expect(await emulatorDetectorPlugin.getPlatformVersion(), '42');
  });
}
