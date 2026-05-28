import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/portfolio_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          ref.read(portfolioControllerProvider).setActiveSection('About');
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Me',
              style: Theme.of(context).textTheme.displayMedium,
            ).animate().fade(duration: 500.ms).slideX(begin: -0.2),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppConstants.accentGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().scaleX(
              begin: 0,
              alignment: Alignment.centerLeft,
              delay: 300.ms,
              duration: 500.ms,
            ),
            const SizedBox(height: 40),

            if (isMobile) ...[
              _buildBio(context),
              const SizedBox(height: 60),
              _buildTimeline(context),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildBio(context)),
                  const SizedBox(width: 60),
                  Expanded(flex: 3, child: _buildTimeline(context)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who am I?',
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
        const SizedBox(height: 20),
        Text(
          AppConstants.bio,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.justify,
        ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
        const SizedBox(height: 30),
        ...List.generate(
          AppConstants.experiences.length,
          (index) => _ExperienceCard(
            experience: AppConstants.experiences[index],
            index: index,
          ),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final dynamic experience;
  final int index;

  const _ExperienceCard({required this.experience, required this.index});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exp = widget.experience;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child:
          MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  transform: Matrix4.identity()
                    ..translate(0.0, _isHovered ? -8.0 : 0.0),
                  child: Card(
                    elevation: _isHovered ? 12 : 0,
                    shadowColor: theme.primaryColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _isHovered
                            ? theme.primaryColor.withOpacity(0.8)
                            : theme.dividerColor,
                        width: _isHovered ? 2.0 : 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  exp.role,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(
                                    _isHovered ? 0.2 : 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: theme.primaryColor.withOpacity(
                                      _isHovered ? 0.8 : 0.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  exp.period,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) =>
                                AppConstants.accentGradient.createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            child: Text(
                              exp.company,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            exp.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...exp.achievements
                              .map<Widget>(
                                (ach) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.only(
                                          top: 2,
                                          right: 12,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor.withOpacity(
                                            _isHovered ? 0.2 : 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: theme.primaryColor,
                                          size: 14,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ach,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(height: 1.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fade(delay: (300 + (widget.index * 200)).ms)
              .slideX(begin: 0.2),
    );
  }
}
