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
    this.ticker,
    this.loopTicker = true,
  })  : _values = values,
        _autostart = autostart {
    _value = initialValue ?? values.first;
    _index = _values.indexOf(_value);
  }

  late T _value;
  final List<T> _values;

  final bool _autostart;

  /// An optional ticker, when informed the state will change on each tick.
  final Duration? ticker;

  /// When a ticker is informed, this flag indicates if the state should loop
  /// when running through all the values.
  final bool loopTicker;

  late int _index;

  /// Returns the current value of the state.
  T get value => _value;

  /// Sets a new value.
  set value(T v) {
    _value = v;
    _index = _values.indexOf(_value);
    notifyListeners();
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

  /// Sets the first value as the current and notify its listeners right after.
  void start() {
    value = _values.first;
    notifyListeners();
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

  /// Called when the Phased state is initialized.
  void onInit() {}
}

class _PhasedState<T> extends State<Phased<T>>
    with SingleTickerProviderStateMixin {
  AnimationController? _ticker;

  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();

    widget.state.addListener(_update);

    if (widget.state.ticker != null) {
      _ticker = AnimationController(vsync: this, duration: widget.state.ticker)
        ..addListener(() {
          final now = DateTime.now();
          if (_lastUpdated == null ||
              now.millisecondsSinceEpoch -
                      _lastUpdated!.millisecondsSinceEpoch >=
                  widget.state.ticker!.inMilliseconds) {
            widget.state.next(loop: widget.state.loopTicker);
            _lastUpdated = now;
          }
        });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ticker != null) {
        _ticker!.repeat(period: widget.state.ticker);
      } else if (widget.state._autostart) {
        widget.state.next();
      }
    });

    widget.onInit();
  }

  @override
  void didUpdateWidget(Phased<T> old) {
    super.didUpdateWidget(old);
    old.state.removeListener(_update);
    widget.state.addListener(_update);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    widget.state.removeListener(_update);

    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.build(context);
}
