import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talha_portfolio/utils/app_assets.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/portfolio_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useColumnLayout = !ResponsiveLayout.isDesktop(context);
    final size = MediaQuery.sizeOf(context);

    return VisibilityDetector(
      key: const Key('hero-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          ref.read(portfolioControllerProvider).setActiveSection('Hero');
        }
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: size.height - 80, // Subtract navbar height
        ),
        padding: EdgeInsets.symmetric(
          horizontal: useColumnLayout ? 20 : 40,
          vertical: useColumnLayout ? 40 : 60,
        ),
        child: useColumnLayout
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _AnimatedAvatar(),
                  const SizedBox(height: 40),
                  _buildContent(context, ref, useColumnLayout),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildContent(context, ref, useColumnLayout)),
                  const SizedBox(width: 60),
                  const _AnimatedAvatar(),
                ],
              ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    bool useColumnLayout,
  ) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Calculate dynamic scaling factor for fonts on smaller screens
    final double fontScale = useColumnLayout
        ? (screenWidth < 480 ? 0.75 : 0.85)
        : 1.0;

    return Column(
      crossAxisAlignment: useColumnLayout
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Hi, I'm",
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize:
                (theme.textTheme.displaySmall?.fontSize ?? 28) * fontScale,
          ),
        ).animate().fade(duration: 600.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 10),
        Text(
              AppConstants.fullName,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize:
                    (theme.textTheme.displayLarge?.fontSize ?? 56) * fontScale,
                foreground: Paint()
                  ..shader = AppConstants.heroTextGradient.createShader(
                    Rect.fromLTWH(
                      0.0,
                      0.0,
                      useColumnLayout ? 300.0 : 400.0,
                      100.0,
                    ),
                  ),
              ),
              textAlign: useColumnLayout ? TextAlign.center : TextAlign.left,
            )
            .animate()
            .fade(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.1, end: 0),
        const SizedBox(height: 10),
        Text(
              AppConstants.title,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize:
                    (theme.textTheme.displayMedium?.fontSize ?? 40) * fontScale,
              ),
              textAlign: useColumnLayout ? TextAlign.center : TextAlign.left,
            )
            .animate()
            .fade(delay: 400.ms, duration: 600.ms)
            .slideX(begin: -0.1, end: 0),
        const SizedBox(height: 20),
        Text(
          AppConstants.tagline,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * fontScale,
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.normal,
          ),
          textAlign: useColumnLayout ? TextAlign.center : TextAlign.left,
        ).animate().fade(delay: 600.ms, duration: 600.ms),
        const SizedBox(height: 40),
        Wrap(
              alignment: useColumnLayout
                  ? WrapAlignment.center
                  : WrapAlignment.start,
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildCTAButton(
                  context,
                  'Download CV',
                  Icons.download,
                  isPrimary: true,
                  useColumnLayout: useColumnLayout,
                  onPressed: () => _launchUrl(AppConstants.cvUrl),
                ),
                _buildCTAButton(
                  context,
                  'Contact Me',
                  Icons.mail,
                  isPrimary: false,
                  useColumnLayout: useColumnLayout,
                  onPressed: () {
                    final pc = ref.read(portfolioControllerProvider);
                    pc.scrollToSection(pc.contactKey);
                  },
                ),
              ],
            )
            .animate()
            .fade(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 40),
        Wrap(
          alignment: useColumnLayout
              ? WrapAlignment.center
              : WrapAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildSocialIcon(context, Icons.code, AppConstants.github),
            _buildSocialIcon(context, Icons.work, AppConstants.linkedin),
            _buildSocialIcon(
              context,
              Icons.email,
              'mailto:${AppConstants.email}',
            ),
          ],
        ).animate().fade(delay: 1000.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildCTAButton(
    BuildContext context,
    String text,
    IconData icon, {
    required bool isPrimary,
    required bool useColumnLayout,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: useColumnLayout ? null : 220,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isPrimary ? AppConstants.accentGradient : null,
          border: isPrimary
              ? null
              : Border.all(color: theme.primaryColor, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : theme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isPrimary ? Colors.white : theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, String url) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(50),
      hoverColor: theme.primaryColor.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.dividerColor),
        ),
        child: Icon(icon, color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _AnimatedAvatar extends StatefulWidget {
  const _AnimatedAvatar();

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    final double widgetSize = isMobile
        ? math.min(320.0, screenWidth - 40)
        : (isTablet ? 360.0 : 400.0);
    final double avatarSize = widgetSize * 0.75;
    final double orbitRadius = widgetSize * 0.425;
    final double iconSize = widgetSize * 0.12;

    return SizedBox(
      width: widgetSize,
      height: widgetSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The floating avatar
          Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppConstants.neonGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.neonBlue.withOpacity(0.5),
                      blurRadius: widgetSize * (30 / 400),
                      spreadRadius: widgetSize * (5 / 400),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(widgetSize * (5 / 400)),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.darkBgColor,
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: avatarSize / 2 - 10,
                        backgroundImage: const AssetImage(
                          AppAssets.profileImage,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -10,
                end: 10,
                duration: 3.seconds,
                curve: Curves.easeInOut,
              ),

          // The orbiting icons
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  _buildOrbitIcon(
                    svgAsset: AppAssets.dartSvg,
                    color: const Color(0xFF0175C2),
                    angle: _controller.value * 2 * math.pi,
                    radius: orbitRadius,
                    center: widgetSize / 2,
                    iconSize: iconSize,
                  ),
                  _buildOrbitIcon(
                    svgAsset: AppAssets.flutterSvg,
                    color: const Color(0xFF02569B),
                    angle: _controller.value * 2 * math.pi + (math.pi / 2),
                    radius: orbitRadius,
                    center: widgetSize / 2,
                    iconSize: iconSize,
                  ),

                  _buildOrbitIcon(
                    svgAsset: AppAssets.githubSvg,
                    color: const Color(0xFF000000),
                    angle: _controller.value * 2 * math.pi + math.pi,
                    radius: orbitRadius,
                    center: widgetSize / 2,
                    iconSize: iconSize,
                  ),

                  _buildOrbitIcon(
                    svgAsset: AppAssets.vsCodeSvg,
                    color: const Color(0xFF007ACC),
                    angle: _controller.value * 2 * math.pi + (3 * math.pi / 2),
                    radius: orbitRadius,
                    center: widgetSize / 2,
                    iconSize: iconSize,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitIcon({
    required String svgAsset,
    required Color color,
    required double angle,
    required double radius,
    required double center,
    required double iconSize,
  }) {
    final offset = iconSize / 2;
    final x = center + radius * math.cos(angle) - offset;
    final y = center + radius * math.sin(angle) - offset;

    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: iconSize,
        height: iconSize,
        padding: EdgeInsets.all(iconSize * (10 / 48)),
        decoration: BoxDecoration(
          color: AppConstants.darkCardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: iconSize * (12 / 48),
              spreadRadius: iconSize * (2 / 48),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: iconSize * (10 / 48),
              offset: Offset(0, iconSize * (4 / 48)),
            ),
          ],
        ),
        child: SvgPicture.asset(
          svgAsset,
          width: iconSize * (24 / 48),
          height: iconSize * (24 / 48),
          color: svgAsset == AppAssets.githubSvg ? Colors.white : null,
        ),
      ),
    );
  }
}
