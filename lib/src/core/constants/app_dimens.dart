/// Default spacing, sizing, and radius constants used across the widget kit.
///
/// Widgets expose these as overridable parameters; these values are only the
/// fallback defaults.
class AppDimens {
  const AppDimens._();

  /// Default corner radius for cards and buttons.
  static const double radiusM = 12.0;

  /// Small corner radius, used for badges and chips.
  static const double radiusS = 6.0;

  /// Large corner radius, used for bottom sheets and prominent surfaces.
  static const double radiusL = 20.0;

  /// Default extra-small spacing unit.
  static const double spaceXs = 4.0;

  /// Default small spacing unit.
  static const double spaceS = 8.0;

  /// Default medium spacing unit.
  static const double spaceM = 16.0;

  /// Default large spacing unit.
  static const double spaceL = 24.0;

  /// Default height for primary action buttons.
  static const double buttonHeight = 44.0;

  /// Default size for icon-only circular buttons (e.g. favorite button).
  static const double iconButtonSize = 40.0;

  /// Default size for a single star in a rating widget.
  static const double starSize = 18.0;
}
