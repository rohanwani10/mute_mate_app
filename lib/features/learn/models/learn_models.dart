class Category {
  final String id;
  final String name;
  final IconType icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}

enum IconType {
  autoAwesome,
  routine,
  mood,
  work,
  medicalServices,
  flight,
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String level;
  final bool isTrending;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.level,
    this.isTrending = false,
  });
}
