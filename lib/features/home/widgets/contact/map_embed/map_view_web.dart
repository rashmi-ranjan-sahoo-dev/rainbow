import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// High-reliability, interactive map embed using Leaflet and OpenStreetMap.
/// Completely immune to X-Frame-Options / CSP restrictions on Netlify and third-party domains.
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
  static const String _viewTypeId = 'rainbow-eye-hospital-live-map';
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
          final htmlContent = _buildMapHtml();
          final iframe = web.HTMLIFrameElement()
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.borderRadius = '20px'
            ..allowFullscreen = true
            ..loading = 'lazy'
            ..src = 'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}'
            ..setAttribute('srcdoc', htmlContent);
          return iframe;
        },
      );
      _isRegistered = true;
    }
  }

  static String _buildMapHtml() {
    return '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>Rainbow Eye Hospital Location Map</title>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body, #map { width: 100%; height: 100%; overflow: hidden; background: #f8fafc; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    .custom-marker {
      display: flex;
      flex-direction: column;
      align-items: center;
      cursor: pointer;
    }
    .pin-pulse {
      position: absolute;
      width: 46px;
      height: 46px;
      border-radius: 50%;
      background: rgba(8, 145, 178, 0.45);
      animation: pulse 2s infinite ease-out;
      top: -7px;
      left: 37px;
    }
    @keyframes pulse {
      0% { transform: scale(0.6); opacity: 0.8; }
      100% { transform: scale(1.6); opacity: 0; }
    }
    .pin-circle {
      position: relative;
      width: 32px;
      height: 32px;
      background: linear-gradient(135deg, #06B6D4, #0891B2, #0E7490);
      border-radius: 50%;
      border: 2.5px solid #ffffff;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 12px rgba(8, 145, 178, 0.45);
      margin: 0 auto;
    }
    .pin-tag {
      margin-top: 4px;
      background: #0F172A;
      color: #ffffff;
      font-size: 11px;
      font-weight: 700;
      padding: 3px 8px;
      border-radius: 6px;
      white-space: nowrap;
      box-shadow: 0 2px 8px rgba(0,0,0,0.25);
    }
    .leaflet-popup-content-wrapper {
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.18);
      padding: 4px;
    }
    .popup-card {
      padding: 6px;
      font-family: inherit;
    }
    .popup-title {
      font-size: 13px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 2px;
    }
    .popup-desc {
      font-size: 11px;
      color: #64748B;
      margin-bottom: 8px;
    }
    .popup-btn {
      display: inline-block;
      background: #0891B2;
      color: #ffffff !important;
      text-decoration: none;
      font-size: 11px;
      font-weight: 600;
      padding: 6px 12px;
      border-radius: 6px;
      transition: background 0.2s;
    }
    .popup-btn:hover {
      background: #0E7490;
    }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    var lat = 17.7449;
    var lng = 83.2646;
    var map = L.map('map', {
      zoomControl: true,
      scrollWheelZoom: true
    }).setView([lat, lng], 16);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '© OpenStreetMap'
    }).addTo(map);

    var customIcon = L.divIcon({
      className: 'custom-marker-wrapper',
      html: '<div class="custom-marker"><div class="pin-pulse"></div><div class="pin-circle"><svg width="16" height="16" fill="white" viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg></div><div class="pin-tag">Rainbow Eye Hospital</div></div>',
      iconSize: [120, 60],
      iconAnchor: [60, 16]
    });

    var marker = L.marker([lat, lng], {icon: customIcon}).addTo(map);
    
    marker.bindPopup(
      '<div class="popup-card">' +
      '<div class="popup-title">Rainbow Eye Hospital</div>' +
      '<div class="popup-desc">Opp. SVBN EM School, Kapparada, Madhavadhara, Visakhapatnam – 530018</div>' +
      '<a class="popup-btn" href="https://www.google.com/maps/dir/?api=1&destination=Rainbow+Eye+Hospital+Madhavadhara+Visakhapatnam" target="_blank">Get Directions on Google Maps ↗</a>' +
      '</div>'
    );
  </script>
</body>
</html>''';
  }

  @override
  Widget build(BuildContext context) {
    _ensureFactoryRegistered();
    return const HtmlElementView(
      viewType: _viewTypeId,
    );
  }
}
