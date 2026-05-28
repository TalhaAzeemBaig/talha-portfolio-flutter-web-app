import 'package:flutter/material.dart';
import 'package:talha_portfolio/utils/app_assets.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';
import '../models/experience_model.dart';

class AppConstants {
  // Personal Details
  static const String fullName = 'Talha Azeem Baig';
  static const String title = 'Flutter Developer';
  static const String tagline =
      'Building high-performance, futuristic, and beautiful multi-platform applications.';
  static const String bio =
      'I am a passionate Flutter Developer with 2+ years of professional experience crafting robust, responsive, and pixel-perfect applications for mobile, tablet, desktop, and web. '
      'My passion lies in implementing scalable architectures, solid state management patterns, and cutting-edge UI/UX. '
      'I specialize in turning complex design prototypes into pixel-perfect interactive digital experiences, integrating Firebase/Supabase backends, REST APIs, and writing clean, maintainable code.';

  static const String email = 'talhaazeembaig@gmail.com';
  static const String github = 'https://github.com/talha-developer';
  static const String linkedin = 'www.linkedin.com/in/talha-azeem-baig';
  static const String cvUrl =
      'https://drive.google.com/file/d/1ln3xRDt6itNdHUm7ZRMcQe9wVf-qTNPC/view?usp=sharing'; // Placeholder
  static const String location = 'Karachi, Pakistan';

  // Styling Tokens - Dark Mode
  static const Color darkBgColor = Color(
    0xFF0A0C16,
  ); // Bottom color (Near Black)
  static const Color darkCardColor = Color(0xFF1B1D4A); // 3rd color (Deep Navy)
  static const Color darkAccentColor = Color(
    0xFF323CE8,
  ); // Top color (Vibrant Royal Blue)
  static const Color darkAccentColor2 = Color(0xFF1C34A0); // 2nd color (Indigo)
  static const Color darkTextColor = Color(0xFFE2E8F0);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  // Styling Tokens - Light Mode
  static const Color lightBgColor = Color(0xFFF8FAFC);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightAccentColor = Color(0xFF0EA5E9); // Electric Blue
  static const Color lightAccentColor2 = Color(0xFF7C3AED); // Indigo
  static const Color lightTextColor = Color(0xFF0F172A);
  static const Color lightTextMuted = Color(0xFF475569);

  // Common Colors
  static const Color neonCyan = Color(0xFF4550FF); // Lighter Blue
  static const Color neonBlue = Color(0xFF323CE8); // Royal Blue
  static const Color neonPurple = Color(0xFF1C34A0); // Indigo
  static const Color glassBorderDark = Color(0x1FFFFFFF);
  static const Color glassBorderLight = Color(0x1F000000);

  // Gradients
  static const Gradient neonGradient = LinearGradient(
    colors: [neonCyan, neonBlue, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroTextGradient = LinearGradient(
    colors: [Color(0xFF4550FF), Color(0xFF323CE8), Color(0xFF1C34A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFF323CE8), Color(0xFF1C34A0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Mock Skills
  static const List<Skill> skills = [
    // Frontend
    Skill(name: 'Dart', category: SkillCategory.frontend, proficiency: 0.60),
    Skill(name: 'Flutter', category: SkillCategory.frontend, proficiency: 0.60),
    Skill(
      name: 'UI/UX Implementation',
      category: SkillCategory.frontend,
      proficiency: 0.90,
    ),
    Skill(
      name: 'Responsive Design',
      category: SkillCategory.frontend,
      proficiency: 0.92,
    ),

    // Backend
    Skill(name: 'Firebase', category: SkillCategory.backend, proficiency: 0.88),
    Skill(
      name: 'REST APIs',
      category: SkillCategory.backend,
      proficiency: 0.90,
    ),
    Skill(
      name: 'Flutter Secure Storage',
      category: SkillCategory.backend,
      proficiency: 0.85,
    ),
    Skill(name: 'Supabase', category: SkillCategory.backend, proficiency: 0.82),

    // State Management
    Skill(
      name: 'Provider',
      category: SkillCategory.stateManagement,
      proficiency: 0.88,
    ),
    Skill(
      name: 'Riverpod',
      category: SkillCategory.stateManagement,
      proficiency: 0.92,
    ),
    Skill(
      name: 'GetX',
      category: SkillCategory.stateManagement,
      proficiency: 0.90,
    ),
    Skill(
      name: 'State Management (General)',
      category: SkillCategory.stateManagement,
      proficiency: 0.92,
    ),

    // Tools
    Skill(
      name: 'Clean Architecture',
      category: SkillCategory.tools,
      proficiency: 0.88,
    ),
    Skill(
      name: 'Git & GitHub',
      category: SkillCategory.tools,
      proficiency: 0.90,
    ),
    Skill(
      name: 'Push Notifications',
      category: SkillCategory.tools,
      proficiency: 0.85,
    ),
    Skill(
      name: 'Performance Optimization',
      category: SkillCategory.tools,
      proficiency: 0.87,
    ),
  ];

  // Mock Experience Timeline
  static const List<Experience> experiences = [
    Experience(
      period: '2024 - Present',
      role: 'Junior Flutter Developer',
      company: 'Digitect Infra Associates',
      description:
          'Building and maintaining various applications for clients, implementing new features, optimizing performance, and fixing bugs.',
      achievements: [
        'Migrated app state management to Riverpod, improving state lifecycle reliability by 40%',
        'Established responsive web support enabling a single codebase for Android, iOS, and Web platforms',
        'Implemented pixel-perfect designs with custom micro-animations utilizing flutter_animate',
      ],
    ),
  ];

  // Mock Projects
  static const List<Project> projects = [
    Project(
      id: '1',
      title: 'Naikify App',
      description:
          'Secure phone-auth platform for donating essentials with integrated payments and beneficiary management.',
      imageUrl: AppAssets.naikifyApp,
      technologies: [
        'Flutter',
        'Riverpod',
        'Firebase Auth',
        'Stripe API',
        'Responsive Design',
        'Notifications',
      ],
      githubUrl: 'https://github.com/talha-developer/ecommerce_space',
      liveUrl:
          'https://play.google.com/store/apps/details?id=com.naikify.digitech&pcampaignid=web_share',
      category: 'Mobile App',
    ),
    Project(
      id: '2',
      title: 'CD Conference 2026',
      description:
          'Unlock the ultimate Malaysian adventure with customized travel schedules and secure ticket management. Stay connected and organized every step of your journey.',
      imageUrl: AppAssets.tourToMalasya,
      technologies: [
        'Flutter',
        'Riverpod',
        'Firebase Notifications',
        'WebSockets',
        'Clean Architecture',
      ],
      githubUrl: 'https://github.com/talha-developer/glassmorphic_chat',
      liveUrl:
          'https://play.google.com/store/apps/details?id=com.travelmalaysia.bolt&pcampaignid=web_share',
      category: 'Mobile App',
    ),
    Project(
      id: '3',
      title: 'Event Link',
      description:
          'Event registration, speaker information and live schedules — built for seamless participation at scale.',
      imageUrl: AppAssets.evenlink,
      technologies: [
        'Flutter',
        'Riverpod',
        'REST APIs',
        "Notifications",
        "Flutter Secure Storage",
      ],
      githubUrl: 'https://github.com/talha-developer/cyberguard_vpn',
      liveUrl:
          'https://play.google.com/store/apps/details?id=com.app.event_link&pcampaignid=web_share',
      category: 'Mobile App',
    ),

    Project(
      id: '4',
      title: 'Heath Solutiona',
      description:
          'A visual task dashboard with dragging boards, task lists, calendar synchronization, automatic notifications, and detailed productivity logs.',
      imageUrl: AppAssets.healthsolution,
      technologies: [
        'Flutter Mobile',
        'Riverpod',
        'Flutter Secure Storage',
        'Google Map',
        'Responsiveness',
      ],
      githubUrl: 'https://github.com/talha-developer/quantum_tasks',
      liveUrl: 'https://quantum-tasks.web.app',
      category: 'Mobile App',
    ),
    Project(
      id: '5',
      title: 'Naikify Web',
      description:
          'A secure web platform for donating essentials with integrated payments and beneficiary management, built with Flutter Web.',
      imageUrl: AppAssets.naikefyWeb,
      technologies: [
        'Flutter',
        'Riverpod',
        'REST APIs',
        'Charts',
        'Web Responsiveness',
      ],
      githubUrl: 'https://github.com/talha-developer/smart_city',
      liveUrl: 'https://smart-city-dash.web.app',
      category: 'Web App',
    ),
    Project(
      id: '6',
      title: 'NetVelocity App',
      description:
          'A network performance monitoring app that tracks real-time speed, latency, and data usage with historical analytics and alerts.',
      imageUrl: AppAssets.netVelocityApp,
      technologies: [
        'Flutter',
        'Bloc',
        'Firebase',
        'Google Maps API',
        'Push Notifications',
      ],
      githubUrl: 'https://github.com/talha-developer/hyper_delivery',
      liveUrl: 'https://hyper-delivery.web.app',
      category: 'Mobile App',
    ),
  ];
}
