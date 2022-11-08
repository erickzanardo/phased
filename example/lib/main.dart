import 'package:example/blink.dart';
import 'package:example/complex_animation.dart';
import 'package:flutter/material.dart';
import 'package:phased/phased.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final manualState = PhasedState(
      values: [true, false],
      autostart: false,
    );
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Text('Autostart'),
                  Blink(
                    state: BlinkState(),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(),
                  const Text('Manual'),
                  ElevatedButton(
                    onPressed: () {
                      manualState.start();
                    },
                    child: const Text('Start'),
                  ),
                  Blink(
                    state: manualState,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 100),
                  const ComplexAnimation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
