import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/portfolio_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';

class ContactSection extends ConsumerStatefulWidget {
  const ContactSection({super.key});

  @override
  ConsumerState<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends ConsumerState<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(portfolioControllerProvider.notifier)
          .submitContactForm(
            name: _nameController.text,
            email: _emailController.text,
            message: _messageController.text,
          )
          .then((success) {
            if (success) {
              _nameController.clear();
              _emailController.clear();
              _messageController.clear();
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          ref.read(portfolioControllerProvider).setActiveSection('Contact');
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
              'Get In Touch',
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
            const SizedBox(height: 60),

            if (isMobile) ...[
              _buildContactInfo(context),
              const SizedBox(height: 60),
              _buildContactForm(context),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildContactInfo(context)),
                  const SizedBox(width: 80),
                  Expanded(flex: 3, child: _buildContactForm(context)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's build something amazing together.",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
        const SizedBox(height: 40),
        _buildInfoCard(
          context,
          Icons.email,
          'Email',
          AppConstants.email,
          () => _launchUrl('mailto:${AppConstants.email}'),
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          context,
          Icons.location_on,
          'Location',
          AppConstants.location,
          null,
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          context,
          Icons.work,
          'LinkedIn',
          'linkedin.com/in/talha-developer',
          () => _launchUrl(AppConstants.linkedin),
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          context,
          Icons.code,
          'GitHub',
          'https://github.com/talhaDigitech',
          () => _launchUrl(AppConstants.github),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return _InfoCardWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    ).animate().fade(delay: 400.ms).slideX(begin: -0.2);
  }

  Widget _buildContactForm(BuildContext context) {
    final theme = Theme.of(context);
    final status = ref.watch(portfolioControllerProvider).contactStatus;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              hintText: 'John Doe',
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your name'
                : null,
          ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Your Email',
              hintText: 'john@example.com',
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter your email';
              if (!value.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ).animate().fade(delay: 300.ms).slideY(begin: 0.2),
          const SizedBox(height: 24),
          TextFormField(
            controller: _messageController,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Your Message',
              hintText: 'Hello, I have a project...',
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your message'
                : null,
          ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 32),
          _GradientSendButton(
            status: status,
            onPressed: _submitForm,
          ).animate().fade(delay: 500.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Could not launch $urlString: $e');
    }
  }
}

class _GradientSendButton extends StatefulWidget {
  final ContactStatus status;
  final VoidCallback onPressed;

  const _GradientSendButton({required this.status, required this.onPressed});

  @override
  State<_GradientSendButton> createState() => _GradientSendButtonState();
}

class _GradientSendButtonState extends State<_GradientSendButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          onTap: widget.status == ContactStatus.sending
              ? null
              : widget.onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              gradient: AppConstants.accentGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: _buildButtonChild(widget.status),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonChild(ContactStatus status) {
    switch (status) {
      case ContactStatus.sending:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        );
      case ContactStatus.success:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Message Sent',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        );
      case ContactStatus.error:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Error Sending',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        );
      case ContactStatus.idle:
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Send Message',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
    }
  }
}

class _InfoCardWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoCardWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<_InfoCardWidget> createState() => _InfoCardWidgetState();
}

class _InfoCardWidgetState extends State<_InfoCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -5.0 : 0.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? theme.primaryColor.withOpacity(0.8)
                  : theme.dividerColor,
              width: _isHovered ? 2.0 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppConstants.accentGradient,
                  shape: BoxShape.circle,
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppConstants.neonPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          _isHovered ? 1.0 : 0.8,
                        ),
                        fontWeight: _isHovered
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
