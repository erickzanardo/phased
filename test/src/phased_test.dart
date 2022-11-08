// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phased/phased.dart';

class BlinkState extends PhasedState<bool> {
  BlinkState() : super(values: [true, false]);
}

class Blink extends Phased<bool> {
  const Blink({
    super.key,
    required super.state,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      state.phaseValue(
        values: {true: 'A'},
        defaultValue: 'B',
      ),
    );
  }
}

void main() {
  group('Phased', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Blink(
                state: BlinkState(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 11));

      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('can not autostart', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Blink(
                state: PhasedState(
                  values: [true, false],
                  autostart: false,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 11));

      expect(find.text('B'), findsNothing);
    });

    testWidgets('sets the values correctly', (tester) async {
      final state = PhasedState(
        values: [true, false],
        autostart: false,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Blink(state: state),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      state.value = false;

      await tester.pump();

      expect(find.text('B'), findsOneWidget);
    });
    testWidgets('can be manually started', (tester) async {
      final state = PhasedState(
        values: [true, false],
        autostart: false,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Blink(state: state),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      state.start();

      await tester.pump();

      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('loops correctly', (tester) async {
      final state = PhasedState(
        values: [true, false],
        autostart: false,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Blink(state: state),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      state.next();

      await tester.pump();

      expect(find.text('B'), findsOneWidget);

      state.next();
      await tester.pump();

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('can not loop', (tester) async {
      final state = PhasedState(
        values: [true, false],
        autostart: false,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Blink(state: state),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      state.next();

      await tester.pump();

      expect(find.text('B'), findsOneWidget);

      state.next(loop: false);
      await tester.pump();

      expect(find.text('B'), findsOneWidget);
      expect(state.value, isFalse);
    });
  });
}
