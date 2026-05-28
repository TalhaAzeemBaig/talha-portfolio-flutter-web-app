class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String githubUrl;
  final String liveUrl;
  final String category; // 'Mobile App', 'Web App', etc.

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.githubUrl,
    required this.liveUrl,
    required this.category,
  });
}
