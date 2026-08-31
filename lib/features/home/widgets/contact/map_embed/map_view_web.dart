import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// High-reliability, interactive Real Google Maps Embed.
class GoogleMapEmbedView extends StatefulWidget {
  final String embedUrl;

  const GoogleMapEmbedView({
    super.key,
    required this.embedUrl,
  });

  @override
  State<GoogleMapEmbedView> createState() => _GoogleMapEmbedViewState();
}

class _GoogleMapEmbedViewState extends State<GoogleMapEmbedView> {
  static const String _viewTypeId = 'rainbow-google-maps-embed';
  static bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _ensureFactoryRegistered();
  }

  void _ensureFactoryRegistered() {
    if (!_isRegistered) {
      ui_web.platformViewRegistry.registerViewFactory(
        _viewTypeId,
        (int viewId) {
          final iframe = web.HTMLIFrameElement()
            ..src = 'https://maps.google.com/maps?q=17.7455424,83.2715274&hl=en&z=17&output=embed'
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%'
            ..allowFullscreen = true
            ..loading = 'lazy'
            ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade')
            ..title = 'Rainbow Eye Hospital Google Map';
          return iframe;
        },
      );
      _isRegistered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureFactoryRegistered();
    return const HtmlElementView(
      viewType: _viewTypeId,
    );
  }
}

