import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// A color in the HSB (HSB) color space.
///
/// The HSB color space contains channels for [hue],
/// [saturation], and [brightness].
class HsbColor extends cm.HsbColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// A color in the HSB (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [brightness] must both be `>= 0` and `<= 100`.
  const HsbColor(
    num hue,
    num saturation,
    num brightness, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(brightness >= 0 && brightness <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(hue, saturation, brightness, alpha);

  @override
  int get value => toColor().value;

  @override
  HsbColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<HsbColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .map<HsbColor>((color) => color.cast())
        .toList();
  }

  @override
  HsbColor get inverted => super.inverted.cast();

  @override
  HsbColor get opposite => super.opposite.cast();

  @override
  HsbColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  HsbColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  HsbColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  HsbColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withSaturation(num saturation) {
    assert(saturation >= 0 && saturation <= 100);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withBrightness(num brightness) {
    assert(brightness >= 0 && brightness <= 100);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toHsbColor();
  }

  @override
  HsbColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toHsbColor();
  }

  @override
  HsbColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toHsbColor();
  }

  @override
  HsbColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  @override
  HsbColor toHsbColor() => this;

  /// Constructs a [HsbColor] from [color].
  factory HsbColor.from(cm.ColorModel color) => color.toHsbColor().cast();

  /// Constructs a [HsbColor] from a list of [hsb] values.
  ///
  /// [hsb] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and value must both be `>= 0` and `<= 100`.
  factory HsbColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HsbColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HslColor] from [color].
  factory HsbColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toHsbColor();

  /// Constructs a [HsbColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HsbColor.fromHex(String hex) => cm.HsbColor.fromHex(hex).cast();

  /// Constructs a [HsbColor] from a list of [hsb] values on a `0` to `1` scale.
  ///
  /// [hsb] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HsbColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HsbColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// Generates a [HsbColor] at random.
  ///
  /// [minHue] and [maxHue] constrain the generated [hue] value. If
  /// `minHue < maxHue`, the range will run in a clockwise direction
  /// between the two, however if `minHue > maxHue`, the range will
  /// run in a counter-clockwise direction. Both [minHue] and [maxHue]
  /// must be `>= 0 && <= 360` and must not be `null`.
  ///
  /// [minSaturation] and [maxSaturation] constrain the generated [saturation]
  /// value.
  ///
  /// [minBrightness] and [maxBrightness] constrain the generated [brightness] value.
  ///
  /// Min and max values, besides hues, must be `min <= max && max >= min`,
  /// must be in the range of `>= 0 && <= 100`, and must not be `null`.
  factory HsbColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minBrightness = 0,
    num maxBrightness = 100,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minBrightness >= 0 && minBrightness <= maxBrightness);
    assert(maxBrightness >= minBrightness && maxBrightness <= 100);
    return cm.HsbColor.random(
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minBrightness: minBrightness,
      maxBrightness: maxBrightness,
    ).cast();
  }

  @override
  HsbColor convert(cm.ColorModel other) => other.toHsbColor().cast();
}
