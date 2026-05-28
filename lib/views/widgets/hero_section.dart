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
    final isMobile = ResponsiveLayout.isMobile(context);
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: isMobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _AnimatedAvatar(),
                  const SizedBox(height: 40),
                  _buildContent(context, ref, isMobile),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildContent(context, ref, isMobile)),
                  const SizedBox(width: 60),
                  const _AnimatedAvatar(),
                ],
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, bool isMobile) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Hi, I'm",
          style: theme.textTheme.displaySmall,
        ).animate().fade(duration: 600.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 10),
        Text(
              AppConstants.fullName,
              style: theme.textTheme.displayLarge?.copyWith(
                foreground: Paint()
                  ..shader = AppConstants.heroTextGradient.createShader(
                    const Rect.fromLTWH(0.0, 0.0, 400.0, 100.0),
                  ),
              ),
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
            )
            .animate()
            .fade(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.1, end: 0),
        const SizedBox(height: 10),
        Text(
              AppConstants.title,
              style: theme.textTheme.displayMedium,
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
            )
            .animate()
            .fade(delay: 400.ms, duration: 600.ms)
            .slideX(begin: -0.1, end: 0),
        const SizedBox(height: 20),
        Text(
          AppConstants.tagline,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.normal,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate().fade(delay: 600.ms, duration: 600.ms),
        const SizedBox(height: 40),
        Wrap(
              alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildCTAButton(
                  context,
                  'Download CV',
                  Icons.download,
                  isPrimary: true,
                  onPressed: () => _launchUrl(AppConstants.cvUrl),
                ),
                _buildCTAButton(
                  context,
                  'Contact Me',
                  Icons.mail,
                  isPrimary: false,
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
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
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
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: ResponsiveLayout.isMobile(context) ? null : 220,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isPrimary ? AppConstants.accentGradient : null,
          border: isPrimary
              ? null
              : Border.all(color: theme.primaryColor, width: 2),
        ),
        child: Row(
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
    const double orbitRadius = 170.0;
    const double avatarSize = 300.0;
    const double widgetSize = 400.0;

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
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.darkBgColor,
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 140,
                        backgroundImage: AssetImage(AppAssets.profileImage),
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
                  ),
                  _buildOrbitIcon(
                    svgAsset: AppAssets.flutterSvg,
                    color: const Color(0xFF02569B),
                    angle: _controller.value * 2 * math.pi + (math.pi / 2),
                    radius: orbitRadius,
                    center: widgetSize / 2,
                  ),

                  _buildOrbitIcon(
                    svgAsset: AppAssets.githubSvg,
                    color: const Color(0xFF000000),
                    angle: _controller.value * 2 * math.pi + math.pi,
                    radius: orbitRadius,
                    center: widgetSize / 2,
                  ),

                  _buildOrbitIcon(
                    svgAsset: AppAssets.vsCodeSvg,
                    color: const Color(0xFF007ACC),
                    angle: _controller.value * 2 * math.pi + (3 * math.pi / 2),
                    radius: orbitRadius,
                    center: widgetSize / 2,
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
  }) {
    // 24 is half of container size (48/2)
    final x = center + radius * math.cos(angle) - 24;
    final y = center + radius * math.sin(angle) - 24;

    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.darkCardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SvgPicture.asset(
          svgAsset,
          width: 24,
          height: 24,
          color: svgAsset == AppAssets.githubSvg ? Colors.white : null,
        ),
      ),
    );
  }
}
