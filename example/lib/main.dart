import 'package:emulator_detector/emulator_detector.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Emulator Detector')),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<bool>(
                future: EmulatorDetector().isEmulator,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data! ? 'شبیه‌ساز شناسایی شد!' : 'دستگاه واقعی است',
                      style: TextStyle(fontSize: 20),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            TextButton(onPressed: () async {
              final data = await  EmulatorDetector().getEmulatorChecks;
              print(data);
            }, child: Text("Logi"))
          ],
        ),
      ),
    );
  }
}