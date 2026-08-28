// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class RealGoogleMapView extends StatefulWidget {
  final String embedUrl;
  final double height;

  const RealGoogleMapView({
    super.key,
    required this.embedUrl,
    this.height = 490,
  });

  @override
  State<RealGoogleMapView> createState() => _RealGoogleMapViewState();
}

class _RealGoogleMapViewState extends State<RealGoogleMapView> {
  static int _viewCounter = 0;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'google-map-iframe-${_viewCounter++}';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '16px'
          ..allowFullscreen = true
          ..setAttribute('loading', 'lazy')
          ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade')
          ..title = 'Rainbow Eye Hospital Google Maps Location';
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: HtmlElementView(viewType: _viewId),
      ),
    );
  }
}
