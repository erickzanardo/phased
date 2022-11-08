import 'package:flutter/material.dart';
import 'package:phased/phased.dart';

class ComplexAnimation extends StatelessWidget {
  const ComplexAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return _Animation(state: PhasedState(values: [0, 1, 2]));
  }
}

class _Animation extends Phased<int> {
  const _Animation({required super.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: state.phaseValue(
        values: {1: 2, 2: 2},
        defaultValue: 0,
      ),
      onEnd: () {
        if (state.value == 1) {
          state.next();
        }
      },
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: state.phaseValue(
          values: {2: 2},
          defaultValue: 1,
        ),
        duration: const Duration(milliseconds: 200),
        onEnd: state.next,
        child: Container(
          color: Colors.blue,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
