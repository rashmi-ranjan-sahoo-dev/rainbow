// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

/// Interactive Google Map iframe container for Flutter Web.
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
  late final String _viewTypeId;

  @override
  void initState() {
    super.initState();
    _viewTypeId = 'rainbow-map-${widget.embedUrl.hashCode}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewTypeId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '20px'
          ..allowFullscreen = true
          ..setAttribute('loading', 'lazy')
          ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade');
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _viewTypeId,
    );
  }
}
