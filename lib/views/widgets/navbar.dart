import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talha_portfolio/utils/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/portfolio_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';

class CustomNavbar extends ConsumerWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(themeControllerProvider);
    final isDark = themeController.isDarkMode;
    final bgColor = isDark
        ? AppConstants.darkBgColor.withOpacity(0.7)
        : AppConstants.lightBgColor.withOpacity(0.7);
    final borderColor = isDark
        ? AppConstants.glassBorderDark
        : AppConstants.glassBorderLight;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveLayout.isMobile(context) ? 20 : 60,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Image.asset(
                isDark
                    ? AppAssets.talhaSignatureInDarkMode
                    : AppAssets.talhaSignatureInLightMode,

                color: isDark ? Colors.white : Colors.black,
              ),

              // Desktop/Tablet Navigation Links
              if (!ResponsiveLayout.isMobile(context))
                Row(
                  children: [
                    _buildNavItem(context, ref, 'Home', 'Hero'),
                    const SizedBox(width: 32),
                    _buildNavItem(context, ref, 'About', 'About'),
                    const SizedBox(width: 32),
                    _buildNavItem(context, ref, 'Skills', 'Skills'),
                    const SizedBox(width: 32),
                    _buildNavItem(context, ref, 'Projects', 'Projects'),
                    const SizedBox(width: 32),
                    _buildNavItem(context, ref, 'Contact', 'Contact'),
                    const SizedBox(width: 32),
                    _buildThemeToggle(ref, isDark),
                  ],
                )
              else
                // Mobile Menu Button
                Row(
                  children: [
                    _buildThemeToggle(ref, isDark),
                    const SizedBox(width: 12),
                    _MenuButton(
                      isDark: isDark,
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(WidgetRef ref, bool isDark) {
    return _ThemeToggleWidget(ref: ref, isDark: isDark);
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref,
    String title,
    String section,
  ) {
    return _NavItemWidget(title: title, section: section, ref: ref);
  }
}

// Drawer for Mobile
class MobileDrawer extends ConsumerWidget {
  const MobileDrawer({super.key});

  static const List<_DrawerNavItem> _navItems = [
    _DrawerNavItem(title: 'Home', section: 'Hero', icon: Icons.home_rounded),
    _DrawerNavItem(
      title: 'About',
      section: 'About',
      icon: Icons.person_rounded,
    ),
    _DrawerNavItem(
      title: 'Skills',
      section: 'Skills',
      icon: Icons.code_rounded,
    ),
    _DrawerNavItem(
      title: 'Projects',
      section: 'Projects',
      icon: Icons.work_rounded,
    ),
    _DrawerNavItem(
      title: 'Contact',
      section: 'Contact',
      icon: Icons.mail_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(themeControllerProvider);
    final isDark = themeController.isDarkMode;
    final theme = Theme.of(context);

    final drawerBg = isDark
        ? AppConstants.darkBgColor
        : AppConstants.lightBgColor;

    return Drawer(
      backgroundColor: drawerBg,
      width: 300,
      child: Column(
        children: [
          // ── Premium Header ──────────────────────────────────────────
          _DrawerHeader(isDark: isDark),

          // ── Nav Items ───────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                return _AnimatedDrawerNavTile(
                  item: item,
                  index: index,
                  isDark: isDark,
                );
              },
            ),
          ),

          // // ── Footer ──────────────────────────────────────────────────
          // _DrawerFooter(isDark: isDark),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data class for nav items
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerNavItem {
  final String title;
  final String section;
  final IconData icon;
  const _DrawerNavItem({
    required this.title,
    required this.section,
    required this.icon,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Premium Drawer Header
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerHeader extends ConsumerWidget {
  final bool isDark;
  const _DrawerHeader({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 28,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0D0F20), Color(0xFF1B1D4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFE8EEFF), Color(0xFFF0F4FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppConstants.glassBorderDark
                : AppConstants.glassBorderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppConstants.neonGradient,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.neonBlue.withOpacity(0.4),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name with gradient
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => AppConstants.heroTextGradient
                .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: const Text(
              'Talha Azeem',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppConstants.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppConstants.darkTextMuted
                  : AppConstants.lightTextMuted,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.green.withOpacity(0.15)
                  : Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.greenAccent : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Available for work',
                  style: TextStyle(
                    color: isDark ? Colors.greenAccent : Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Nav Tile
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedDrawerNavTile extends ConsumerStatefulWidget {
  final _DrawerNavItem item;
  final int index;
  final bool isDark;

  const _AnimatedDrawerNavTile({
    required this.item,
    required this.index,
    required this.isDark,
  });

  @override
  ConsumerState<_AnimatedDrawerNavTile> createState() =>
      _AnimatedDrawerNavTileState();
}

class _AnimatedDrawerNavTileState extends ConsumerState<_AnimatedDrawerNavTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToSection(BuildContext context) {
    final pc = ref.read(portfolioControllerProvider);
    final section = widget.item.section;
    GlobalKey targetKey;
    switch (section) {
      case 'Hero':
        targetKey = pc.heroKey;
        break;
      case 'About':
        targetKey = pc.aboutKey;
        break;
      case 'Skills':
        targetKey = pc.skillsKey;
        break;
      case 'Projects':
        targetKey = pc.projectsKey;
        break;
      case 'Contact':
        targetKey = pc.contactKey;
        break;
      default:
        targetKey = pc.heroKey;
    }
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 120), () {
      pc.scrollToSection(targetKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final portfolioController = ref.watch(portfolioControllerProvider);
    final isActive = portfolioController.activeSection == widget.item.section;
    final isDark = widget.isDark;

    final activeGradient = AppConstants.accentGradient;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            _scrollToSection(context);
          },
          onTapCancel: () => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnim,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          AppConstants.neonBlue.withOpacity(0.18),
                          AppConstants.neonPurple.withOpacity(0.12),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : (_isHovered
                          ? LinearGradient(
                              colors: [
                                AppConstants.neonBlue.withOpacity(0.08),
                                AppConstants.neonPurple.withOpacity(0.05),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive
                      ? AppConstants.neonBlue.withOpacity(0.35)
                      : (_isHovered
                            ? AppConstants.neonBlue.withOpacity(0.15)
                            : Colors.transparent),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Icon container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: isActive ? activeGradient : null,
                      color: isActive
                          ? null
                          : (isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.05)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        widget.item.icon,
                        size: 20,
                        color: isActive
                            ? Colors.white
                            : (isDark
                                  ? AppConstants.darkTextMuted
                                  : AppConstants.lightTextMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title
                  Expanded(
                    child: isActive
                        ? ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) =>
                                activeGradient.createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            child: Text(
                              widget.item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          )
                        : Text(
                            widget.item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: _isHovered
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              letterSpacing: 0.4,
                              color: isDark
                                  ? AppConstants.darkTextColor
                                  : AppConstants.lightTextColor,
                            ),
                          ),
                  ),
                  // Active indicator dot
                  AnimatedOpacity(
                    opacity: isActive ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: activeGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.neonBlue.withOpacity(0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drawer Footer — Theme Toggle + Social Links
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerFooter extends ConsumerWidget {
  final bool isDark;
  const _DrawerFooter({required this.isDark});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppConstants.glassBorderDark
                : AppConstants.glassBorderLight,
          ),
        ),
      ),
      child: Column(
        children: [
          // Theme toggle row
          Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 18,
                color: isDark
                    ? AppConstants.darkTextMuted
                    : AppConstants.lightTextMuted,
              ),
              const SizedBox(width: 10),
              Text(
                isDark ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppConstants.darkTextMuted
                      : AppConstants.lightTextMuted,
                ),
              ),
              const Spacer(),
              // Toggle switch
              _ThemeToggleWidget(ref: ref, isDark: isDark),
            ],
          ),
          const SizedBox(height: 16),
          // Social icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIconButton(
                icon: Icons.code,
                label: 'GitHub',
                url: AppConstants.github,
                isDark: isDark,
                onTap: () => _launchUrl(AppConstants.github),
              ),
              const SizedBox(width: 12),
              _SocialIconButton(
                icon: Icons.work_outline_rounded,
                label: 'LinkedIn',
                url: AppConstants.linkedin,
                isDark: isDark,
                onTap: () => _launchUrl(AppConstants.linkedin),
              ),
              const SizedBox(width: 12),
              _SocialIconButton(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                url: 'mailto:${AppConstants.email}',
                isDark: isDark,
                onTap: () => _launchUrl('mailto:${AppConstants.email}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool isDark;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: _isHovered ? AppConstants.accentGradient : null,
              color: _isHovered
                  ? null
                  : (widget.isDark
                        ? Colors.white.withOpacity(0.07)
                        : Colors.black.withOpacity(0.06)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppConstants.neonBlue.withOpacity(0.35),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 20,
                color: _isHovered
                    ? Colors.white
                    : (widget.isDark
                          ? AppConstants.darkTextMuted
                          : AppConstants.lightTextMuted),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatefulWidget {
  final String title;
  final String section;
  final WidgetRef ref;

  const _NavItemWidget({
    required this.title,
    required this.section,
    required this.ref,
  });

  @override
  State<_NavItemWidget> createState() => _NavItemWidgetState();
}

class _NavItemWidgetState extends State<_NavItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final portfolioController = widget.ref.watch(portfolioControllerProvider);
    final isActive = portfolioController.activeSection == widget.section;
    final theme = Theme.of(context);
    final isHighlighted = isActive || _isHovered;

    Widget textWidget = Text(
      widget.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
        color: isHighlighted
            ? Colors.white
            : theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
        letterSpacing: 1.2,
      ),
    );

    if (isHighlighted) {
      textWidget = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => AppConstants.accentGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: textWidget,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final pc = widget.ref.read(portfolioControllerProvider);
          GlobalKey targetKey;
          switch (widget.section) {
            case 'Hero':
              targetKey = pc.heroKey;
              break;
            case 'About':
              targetKey = pc.aboutKey;
              break;
            case 'Skills':
              targetKey = pc.skillsKey;
              break;
            case 'Projects':
              targetKey = pc.projectsKey;
              break;
            case 'Contact':
              targetKey = pc.contactKey;
              break;
            default:
              targetKey = pc.heroKey;
          }
          pc.scrollToSection(targetKey);
          if (Scaffold.maybeOf(context)?.isEndDrawerOpen ?? false) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          color: Colors.transparent, // Ensures the whole area is clickable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget,
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 3,
                width: isHighlighted ? 30 : 0,
                decoration: BoxDecoration(
                  gradient: AppConstants.accentGradient,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _MenuButton({required this.isDark, required this.onPressed});

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.90,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final hoverBorderColor = isDark
        ? AppConstants.neonBlue.withOpacity(0.7)
        : AppConstants.lightAccentColor.withOpacity(0.7);
    final idleBorderColor = isDark
        ? Colors.white.withOpacity(0.15)
        : Colors.black.withOpacity(0.12);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered
                  ? AppConstants.neonBlue.withOpacity(0.12)
                  : Colors.transparent,
              border: Border.all(
                color: _isHovered ? hoverBorderColor : idleBorderColor,
                width: _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppConstants.neonBlue.withOpacity(0.25),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                child: CustomPaint(
                  size: const Size(18, 14),
                  painter: _HamburgerPainter(
                    isHovered: _isHovered,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HamburgerPainter extends CustomPainter {
  final bool isHovered;
  final bool isDark;

  const _HamburgerPainter({required this.isHovered, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    if (isHovered) {
      // Gradient stroke via shader
      paint.shader = AppConstants.accentGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else {
      paint.color = isDark
          ? Colors.white.withOpacity(0.80)
          : Colors.black.withOpacity(0.70);
      paint.shader = null;
    }

    final double w = size.width;
    final double h = size.height;

    // Top line — full width
    canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
    // Middle line — slightly shorter for visual interest
    canvas.drawLine(Offset(w * 0.12, h / 2), Offset(w * 0.88, h / 2), paint);
    // Bottom line — full width
    canvas.drawLine(Offset(0, h), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(_HamburgerPainter old) =>
      old.isHovered != isHovered || old.isDark != isDark;
}

class _ThemeToggleWidget extends StatefulWidget {
  final WidgetRef ref;
  final bool isDark;

  const _ThemeToggleWidget({required this.ref, required this.isDark});

  @override
  State<_ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<_ThemeToggleWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;
    final iconColor = isDark ? Colors.amber : theme.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.ref.read(themeControllerProvider).toggleTheme(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? theme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? iconColor.withOpacity(0.5)
                  : theme.dividerColor,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: iconColor.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: child.key == const ValueKey('dark')
                      ? Tween<double>(begin: 0.5, end: 1).animate(animation)
                      : Tween<double>(begin: 0, end: 0.5).animate(animation),
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(isDark ? 'dark' : 'light'),
                color: iconColor,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
