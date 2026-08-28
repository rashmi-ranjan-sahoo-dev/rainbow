import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';

/// Device type enum for responsive layouts.
enum DeviceType { mobile, tablet, desktop }

/// Provides responsive layout helpers via [LayoutBuilder] and [MediaQuery].
class ResponsiveHelper {
  ResponsiveHelper._();

  /// Returns the current [DeviceType] based on screen width.
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppBreakpoints.mobile) return DeviceType.mobile;
    if (width < AppBreakpoints.tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  /// Returns appropriate horizontal padding for the current breakpoint.
  static double horizontalPadding(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return AppBreakpoints.paddingMobile;
      case DeviceType.tablet:
        return AppBreakpoints.paddingTablet;
      case DeviceType.desktop:
        return AppBreakpoints.paddingDesktop;
    }
  }
}

/// A widget that builds different layouts based on screen width.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.mobile) {
          return mobile;
        }
        if (constraints.maxWidth < AppBreakpoints.tablet) {
          return tablet ?? mobile;
        }
        return desktop;
      },
    );
  }
}
