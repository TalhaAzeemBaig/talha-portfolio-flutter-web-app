import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/portfolio_controller.dart';
import '../controllers/theme_controller.dart';
import 'widgets/custom_cursor.dart';
import 'widgets/particle_background.dart';
import 'widgets/navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/footer_section.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(themeControllerProvider);
    final portfolioController = ref.watch(portfolioControllerProvider);

    return Scaffold(
      endDrawer: const MobileDrawer(),
      body: CustomCursor(
        isDarkMode: themeController.isDarkMode,
        child: Stack(
          children: [
            // 1. Animated Background
            ParticleBackground(isDarkMode: themeController.isDarkMode),
            
            // 2. Scrollable Content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80), // Offset for sticky navbar
                  HeroSection(key: portfolioController.heroKey),
                  AboutSection(key: portfolioController.aboutKey),
                  SkillsSection(key: portfolioController.skillsKey),
                  ProjectsSection(key: portfolioController.projectsKey),
                  ContactSection(key: portfolioController.contactKey),
                  const FooterSection(),
                ],
              ),
            ),
            
            // 3. Sticky Navigation Bar (on top)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomNavbar(),
            ),
          ],
        ),
      ),
      floatingActionButton: portfolioController.activeSection != 'Hero'
          ? FloatingActionButton(
              onPressed: () => portfolioController.scrollToSection(portfolioController.heroKey),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }
}
