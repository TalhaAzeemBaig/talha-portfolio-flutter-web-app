enum SkillCategory {
  frontend,
  backend,
  stateManagement,
  tools,
}

class Skill {
  final String name;
  final SkillCategory category;
  final double proficiency; // 0.0 to 1.0

  const Skill({
    required this.name,
    required this.category,
    required this.proficiency,
  });

  String get categoryString {
    switch (category) {
      case SkillCategory.frontend:
        return 'Frontend';
      case SkillCategory.backend:
        return 'Backend';
      case SkillCategory.stateManagement:
        return 'State Management';
      case SkillCategory.tools:
        return 'Tools & Others';
    }
  }
}
