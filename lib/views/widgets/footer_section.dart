import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_layout.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                _buildCopyright(theme),
                const SizedBox(height: 16),
                _buildBuiltWith(theme),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCopyright(theme),
                _buildBuiltWith(theme),
              ],
            ),
    );
  }

  Widget _buildCopyright(ThemeData theme) {
    return Text(
      '© ${DateTime.now().year} ${AppConstants.fullName}. All rights reserved.',
      style: theme.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBuiltWith(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Built with ',
          style: theme.textTheme.bodyMedium,
        ),
        const FlutterLogo(size: 16),
        Text(
          ' Flutter Web',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }
}
