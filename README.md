# Phased

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Simplified state management focused on animations

## Installation 💻

**❗ In order to start using Phased you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add `phased` to your `pubspec.yaml`:

```yaml
dependencies:
  phased:
```

Install it:

```sh
flutter packages get
```

## Description

Phased is a simple state management meant to be used to build animations, its objective is to
provide an easy, boilerplateless way to create and manage the state of an animation, so developers
can focus on building the animations themselves.

The package consists of two classes: `PhasedState`, which describes the state and offers control methods for an animation, and `Phased`, an abstract `Widget` that will build the animation itself.

## Example

To build a simple animation that blinks a child using opacity, the following code can be used:

```dart
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
```

Then to use it:

```dart
Blink(
  state: BlinkState(),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
);
```

For more complex examples, check the example folder.

---


[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
