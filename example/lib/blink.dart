import 'package:flutter/material.dart';
import 'package:phased/phased.dart';

class BlinkState extends PhasedState<bool> {
  BlinkState() : super(values: [true, false]);
}

class Blink extends Phased<bool> {
  const Blink({
    super.key,
    required super.state,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: state.phaseValue(
        values: const {true: 1},
        defaultValue: 0,
      ),
      onEnd: state.next,
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}
