import 'package:flutter/material.dart';

class RealGoogleMapView extends StatelessWidget {
  final String embedUrl;
  final double height;

  const RealGoogleMapView({
    super.key,
    required this.embedUrl,
    this.height = 490,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/visakhapatnam_satellite_map.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
