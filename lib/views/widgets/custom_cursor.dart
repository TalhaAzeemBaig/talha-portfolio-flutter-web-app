import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';

class CustomCursor extends StatefulWidget {
  final Widget child;
  final bool isDarkMode;

  const CustomCursor({
    super.key,
    required this.child,
    required this.isDarkMode,
  });

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  Offset _mousePos = Offset.zero;
  Offset _trailPos = Offset.zero;
  bool _isVisible = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    )..repeat();

    _controller.addListener(() {
      if (_isVisible) {
        setState(() {
          // Lerp the trail position towards mouse position for smooth trailing effect
          _trailPos = Offset.lerp(_trailPos, _mousePos, 0.15) ?? _mousePos;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Disable custom cursor on mobile/tablet touch screens
    if (ResponsiveLayout.isMobile(context) || ResponsiveLayout.isTablet(context)) {
      return widget.child;
    }

    final accentColor = widget.isDarkMode
        ? AppConstants.darkAccentColor
        : AppConstants.lightAccentColor;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() {
        _isVisible = true;
      }),
      onExit: (_) => setState(() {
        _isVisible = false;
      }),
      onHover: (event) {
        setState(() {
          _mousePos = event.position;
          if (!_isVisible) _isVisible = true;
        });
      },
      child: Stack(
        children: [
          widget.child,
          if (_isVisible) ...[
            // Trailing Ring
            Positioned(
              left: _trailPos.dx - 16,
              top: _trailPos.dy - 16,
              child: IgnorePointer(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Instant Center Dot
            Positioned(
              left: _mousePos.dx - 4,
              top: _mousePos.dy - 4,
              child: IgnorePointer(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
