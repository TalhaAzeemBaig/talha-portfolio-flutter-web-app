import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talha_portfolio/utils/app_assets.dart';
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
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customNavbar = const CustomNavbar();

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: Center(
              child: Text(
                '<Talha />',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = AppConstants.heroTextGradient.createShader(
                      const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                    ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDrawerItem(context, ref, 'Home', 'Hero', Icons.home),
          _buildDrawerItem(context, ref, 'About', 'About', Icons.person),
          _buildDrawerItem(context, ref, 'Skills', 'Skills', Icons.code),
          _buildDrawerItem(context, ref, 'Projects', 'Projects', Icons.work),
          _buildDrawerItem(context, ref, 'Contact', 'Contact', Icons.mail),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    WidgetRef ref,
    String title,
    String section,
    IconData icon,
  ) {
    final portfolioController = ref.watch(portfolioControllerProvider);
    final isActive = portfolioController.activeSection == section;
    final theme = Theme.of(context);

    Widget textWidget = Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: isActive ? Colors.white : theme.textTheme.bodyLarge?.color,
        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        letterSpacing: 1.0,
      ),
    );

    if (isActive) {
      textWidget = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => AppConstants.accentGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: textWidget,
      );
    }

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? theme.primaryColor : theme.iconTheme.color,
      ),
      title: textWidget,
      onTap: () {
        final pc = ref.read(portfolioControllerProvider);
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
        Navigator.of(context).pop(); // Close drawer
        Future.delayed(const Duration(milliseconds: 100), () {
          pc.scrollToSection(targetKey);
        });
      },
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
