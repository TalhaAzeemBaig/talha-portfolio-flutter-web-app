import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/portfolio_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';
import '../../models/skill_model.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);

    final Map<SkillCategory, List<Skill>> groupedSkills = {
      for (var category in SkillCategory.values)
        category: AppConstants.skills
            .where((s) => s.category == category)
            .toList(),
    };

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          ref.read(portfolioControllerProvider).setActiveSection('Skills');
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
              'Technical Skills',
              style: Theme.of(context).textTheme.displayMedium,
            ).animate().fade(duration: 500.ms).slideX(begin: -0.2),
            const SizedBox(height: 16),
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
            const SizedBox(height: 56),
            ...SkillCategory.values.map((category) {
              final skills = groupedSkills[category] ?? [];
              if (skills.isEmpty) return const SizedBox.shrink();
              return _buildCategory(context, skills);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, List<Skill> skills) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient category label
          ShaderMask(
            shaderCallback: (b) => AppConstants.accentGradient.createShader(b),
            child: Text(
              skills.first.categoryString.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().fade(delay: 150.ms),
          const SizedBox(height: 16),
          // Chip Wrap
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.asMap().entries.map((e) {
              return _SkillChip(skill: e.value, index: e.key);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Icon map ──────────────────────────────────────────────────────────────────
IconData _iconFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('dart')) return Icons.code_rounded;
  if (n.contains('flutter')) return Icons.flutter_dash;
  if (n.contains('ui') || n.contains('ux')) return Icons.palette_rounded;
  if (n.contains('responsive')) return Icons.devices_rounded;
  if (n.contains('firebase')) return Icons.local_fire_department_rounded;
  if (n.contains('rest') || n.contains('api')) return Icons.cloud_rounded;
  if (n.contains('sqlite')) return Icons.storage_rounded;
  if (n.contains('supabase')) return Icons.hub_rounded;
  if (n.contains('riverpod')) return Icons.account_tree_rounded;
  if (n.contains('provider')) return Icons.share_rounded;
  if (n.contains('bloc')) return Icons.layers_rounded;
  if (n.contains('state')) return Icons.sync_alt_rounded;
  if (n.contains('git')) return Icons.merge_type_rounded;
  if (n.contains('architecture')) return Icons.architecture_rounded;
  if (n.contains('notif')) return Icons.notifications_rounded;
  if (n.contains('performance') || n.contains('optim'))
    return Icons.speed_rounded;
  return Icons.star_rounded;
}

// ── Chip ──────────────────────────────────────────────────────────────────────
class _SkillChip extends StatefulWidget {
  final Skill skill;
  final int index;
  const _SkillChip({required this.skill, required this.index});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  static const _g1 = Color(0xFF323CE8);
  static const _g2 = Color(0xFF1C34A0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child:
          AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..translate(0.0, _hovered ? -3.0 : 0.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: _hovered
                      ? const LinearGradient(colors: [_g1, _g2])
                      : null,
                  color: _hovered ? null : theme.cardColor,
                  border: Border.all(
                    color: _hovered
                        ? Colors.transparent
                        : const Color(0xFF323CE8).withOpacity(0.35),
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: _g1.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _iconFor(widget.skill.name),
                      size: 14,
                      color: _hovered ? Colors.white : const Color(0xFF323CE8),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      widget.skill.name,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _hovered
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fade(delay: (60 * widget.index).ms)
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                delay: (60 * widget.index).ms,
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
    );
  }
}
