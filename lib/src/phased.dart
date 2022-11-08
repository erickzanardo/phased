import 'package:flutter/material.dart';

/// {@template phased_state}
/// Holds the state of a [Phased] widget.
/// {@endtemplate}
class PhasedState<T> extends ChangeNotifier {
  /// {@macro phased_state}
  PhasedState({
    required List<T> values,
    bool autostart = true,
    T? initialValue,
  })  : _values = values,
        _autostart = autostart {
    _value = initialValue ?? values.first;
    _index = _values.indexOf(_value);
  }

  late T _value;
  final List<T> _values;

  final bool _autostart;

  late int _index;

  /// Returns the current value of the state.
  T get value => _value;

  /// Sets a new value.
  set value(T v) {
    notifyListeners();
    _value = v;
    _index = _values.indexOf(_value);
  }

  /// Sets the next value of the state. If [loop] is set to true, this method
  /// does nothing if the current value is the next.
  void next({bool loop = true}) {
    if (_index + 1 < _values.length) {
      value = _values[_index + 1];
    } else if (loop) {
      value = _values.first;
    }
  }

  /// Sets the first value as the current and calls [next] right after.
  void start() {
    value = _values.first;
    next();
  }

  /// Returns a mapped value according the [values] map.
  ///
  /// If no value is returned by the mapping, will return [defaultValue].
  V phaseValue<V>({
    required Map<T, V> values,
    required V defaultValue,
  }) {
    return values[_value] ?? defaultValue;
  }
}

/// {@template phased}
/// The base class for a Phased widget. Override it to create custom, phased
/// based animations.
///
/// Example:
/// ```dart
/// class BlinkState extends PhasedState<bool> {
///   BlinkState() : super(values: [true, false]);
/// }
///
/// class Blink extends Phased<bool> {
///   const Blink({
///     super.key,
///     required super.state,
///     required this.child,
///   });
///
///   final Widget child;
///
///   @override
///   Widget build(BuildContext context) {
///     return AnimatedOpacity(
///       opacity: state.phaseValue(
///         values: const {true: 1},
///         defaultValue: 0,
///       ),
///       onEnd: state.next,
///       duration: const Duration(milliseconds: 250),
///       child: child,
///     );
///   }
/// }
/// ```
///
/// {@endtemplate}
abstract class Phased<T> extends StatefulWidget {
  /// {@macro phased}
  const Phased({
    super.key,
    required this.state,
  });

  /// State of the widget.
  final PhasedState<T> state;

  @override
  State<Phased<T>> createState() => _PhasedState<T>();

  /// Override to build the animation.
  Widget build(BuildContext context);
}

class _PhasedState<T> extends State<Phased<T>> {
  @override
  void initState() {
    super.initState();

    widget.state.addListener(_update);

    if (widget.state._autostart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.state.next();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.state.removeListener(_update);
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.build(context);
}
