/// Responsive breakpoints for the Rainbow Eye Hospital app.
class AppBreakpoints {
  AppBreakpoints._();

  /// Anything below this is mobile layout.
  static const double mobile = 650;
  /// Between [mobile] and [tablet] is tablet layout.
  static const double tablet = 1080;

  /// Above [tablet] is desktop layout.
  /// Max-width constraint for content area.
  static const double maxContentWidth = 1280;

  /// Horizontal padding per breakpoint.
  static const double paddingMobile = 16;
  static const double paddingTablet = 24;
  static const double paddingDesktop = 40;
}
