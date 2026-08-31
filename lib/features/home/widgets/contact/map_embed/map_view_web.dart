import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Interactive Google Map iframe container for Flutter Web using modern package:web and WASM-safe API.
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
  static const String _viewTypeId = 'rainbow-google-map-embed-view';
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
            ..src = widget.embedUrl
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.borderRadius = '20px'
            ..allowFullscreen = true
            ..loading = 'lazy';
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
