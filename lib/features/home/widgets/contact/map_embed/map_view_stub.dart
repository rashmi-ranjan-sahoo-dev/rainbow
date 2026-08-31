import 'package:flutter/material.dart';

/// Fallback stub for non-web platforms.
class GoogleMapEmbedView extends StatelessWidget {
  final String embedUrl;

  const GoogleMapEmbedView({
    super.key,
    required this.embedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Text(
          'Live Google Map is active on Web',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
