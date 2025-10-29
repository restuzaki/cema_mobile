import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  static const double _mobileWidthLimit = 650;
  static const double _tabletWidthLimit = 1100;

  const Responsive({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _mobileWidthLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= _mobileWidthLimit &&
      MediaQuery.of(context).size.width < _tabletWidthLimit;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _tabletWidthLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _tabletWidthLimit && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= _mobileWidthLimit && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
