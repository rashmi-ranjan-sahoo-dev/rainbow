import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// A row of social-media icon buttons.
class SocialIconRow extends StatelessWidget {
  final double iconSize;
  final Color iconColor;
  final double spacing;

  const SocialIconRow({
    super.key,
    this.iconSize = 16,
    this.iconColor = Colors.white70,
    this.spacing = 12,
  });

  static final _socials = [
    _SocialItem(FontAwesomeIcons.facebookF, 'https://facebook.com'),
    _SocialItem(FontAwesomeIcons.instagram, 'https://instagram.com'),
    _SocialItem(FontAwesomeIcons.youtube, 'https://youtube.com'),
    _SocialItem(FontAwesomeIcons.linkedinIn, 'https://linkedin.com'),
    _SocialItem(FontAwesomeIcons.xTwitter, 'https://twitter.com'),
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _socials
          .map(
            (s) => Padding(
              padding: EdgeInsets.only(right: spacing),
              child: _SocialIconButton(
                icon: s.icon,
                url: s.url,
                size: iconSize,
                color: iconColor,
                onTap: () => _launch(s.url),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SocialItem {
  final FaIconData icon;
  final String url;
  _SocialItem(this.icon, this.url);
}

class _SocialIconButton extends StatefulWidget {
  final FaIconData icon;
  final String url;
  final double size;
  final Color color;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.url,
    required this.size,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white24 : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: FaIcon(
            widget.icon,
            size: widget.size,
            color: _hovered ? Colors.white : widget.color,
          ),
        ),
      ),
    );
  }
}
