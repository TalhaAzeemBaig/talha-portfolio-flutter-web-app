import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/portfolio_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';
import '../../models/project_model.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final portfolioController = ref.watch(portfolioControllerProvider);
    final selectedCategory = portfolioController.selectedCategory;

    // Get unique categories and prepend 'All'
    final categories = [
      'All',
      ...AppConstants.projects.map((p) => p.category).toSet(),
    ];

    // Filter projects based on selected category
    final filteredProjects = selectedCategory == 'All'
        ? AppConstants.projects
        : AppConstants.projects
              .where((p) => p.category == selectedCategory)
              .toList();

    // Determine grid columns
    int crossAxisCount = 3;
    if (isMobile)
      crossAxisCount = 1;
    else if (isTablet)
      crossAxisCount = 2;

    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) {
          ref.read(portfolioControllerProvider).setActiveSection('Projects');
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
              'Featured Projects',
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

            // Filter Chips
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(portfolioControllerProvider.notifier)
                          .setCategory(cat);
                    }
                  },
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.2),
                  backgroundColor: Theme.of(context).cardColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                );
              }).toList(),
            ).animate().fade(delay: 400.ms),

            const SizedBox(height: 40),

            // Projects Grid
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: GridView.builder(
                key: ValueKey(
                  selectedCategory,
                ), // Triggers animation on filter change
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: isMobile ? 0.8 : 0.85,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                ),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  return _ProjectCard(
                    project: filteredProjects[index],
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final int index;

  const _ProjectCard({required this.project, required this.index});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -10.0 : 0.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: _isHovered ? 12 : 0,
          shadowColor: theme.primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isHovered ? theme.primaryColor : theme.dividerColor,
              width: _isHovered ? 2.0 : 1.0,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Base Layer: Image fully visible with blurred background
              AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Blurred background
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: widget.project.imageUrl.startsWith("https")
                          ? Image.network(
                              widget.project.imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              widget.project.imageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                    // Dark overlay to make the actual image pop
                    Container(color: Colors.black.withOpacity(0.4)),
                    // Actual Image
                    widget.project.imageUrl.startsWith("https")
                        ? Image.network(
                            widget.project.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: theme.dividerColor,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        : Image.asset(
                            widget.project.imageUrl,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
              ),

              // Hover Layer: Glassmorphism overlay with details
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      color: theme.cardColor.withOpacity(
                        0.85,
                      ), // Transparent overlay
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.project.category.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppConstants.neonPurple,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.project.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              widget.project.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.9),
                              ),
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // const SizedBox(height: 12),
                          // Technologies
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.project.technologies.take(3).map((
                              tech,
                            ) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '#$tech',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    // color: theme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          // Action Buttons
                          // if (widget.project.githubUrl.isNotEmpty &&
                          //     widget.project.liveUrl.isNotEmpty)
                          Row(
                            children: [
                              if (widget.project.liveUrl.isNotEmpty)
                                _buildHoverButton(
                                  context,
                                  Icons.link,
                                  widget.project.liveUrl,
                                  'Live Demo',
                                ),
                              if (widget.project.githubUrl.isNotEmpty)
                                const SizedBox(width: 16),
                              if (widget.project.githubUrl.isNotEmpty)
                                _buildHoverButton(
                                  context,
                                  Icons.code,
                                  widget.project.githubUrl,
                                  'Source Code',
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fade(delay: (100 * widget.index).ms).slideY(begin: 0.1),
    );
  }

  Widget _buildHoverButton(
    BuildContext context,
    IconData icon,
    String url,
    String tooltip,
  ) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: TextButton.icon(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        icon: Icon(icon, size: 18, color: theme.primaryColor),
        label: Text(
          tooltip,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: theme.primaryColor.withOpacity(0.15),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
