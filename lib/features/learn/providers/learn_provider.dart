import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learn_models.dart';

final categoriesProvider = Provider<List<Category>>((ref) {
  return [
    Category(id: '1', name: 'Basics', icon: IconType.autoAwesome),
    Category(id: '2', name: 'Daily', icon: IconType.routine),
    Category(id: '3', name: 'Emotions', icon: IconType.mood),
    Category(id: '4', name: 'Workplace', icon: IconType.work),
    Category(id: '5', name: 'Medical', icon: IconType.medicalServices),
    Category(id: '6', name: 'Travel', icon: IconType.flight),
  ];
});

final recentSearchesProvider = Provider<List<String>>((ref) {
  return ['Alphabet', 'Emergency', 'Food'];
});

final trendingLessonsProvider = Provider<List<Lesson>>((ref) {
  return [
    Lesson(
      id: '1',
      title: 'Ordering at a Cafe',
      description: 'Common phrases for social settings.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDRny-kqdaSZMczNyU1wmKK38wfAtiku6810EpLhVSJQ7E0u5dzbJp8kSEEP3CfH4DlLu7pbFikhGd6f3CELJtbkID7-I5jBha7JF7PK19bA6AEjkTsB2okINEihQMp8NklnETq93TkAA1vNytvuQoXHAJsBGWfjlZvmJdCtqomzMh7pZ4FrAyZtBMoHZLZNSiZSQtA8210Pryi-bx4Y6UphZnJl8WkV6nkA6A4K8xox718WIUaPuFpB7PZio8n9J7PlnAbj0w1ZBU3',
      duration: '12m',
      level: 'Beginner',
      isTrending: true,
    ),
    Lesson(
      id: '2',
      title: 'Emergency Support',
      description: 'Vital signs for medical situations.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAhQgqJAYrMKNt0c4r1zX0YJn-dVNIY4mtDWVcVj35zmWM7NQ8WIJ8adMqTYGCI5Vxue9IBUgzPz0WwJ93SZSvwfYRlq5Z1BOTYegQNBKDd1eIj2my-rHvhd-D2FHlD_vUPeywwZnrv6tmEs2wGtJ7jKte9NH0oJqGp3oQTL7tlT_Koq9xu1K85q3mIuPMJsjXfYKdMOLHknlYUqOnA97VAwEUQtJmc3GAiMWq7MfZAw3A5yKVZn-7Lai1QqWBCjOVh6OA8wUr_qWfT',
      duration: '8m',
      level: 'Intermediate',
      isTrending: true,
    ),
    Lesson(
      id: '3',
      title: 'Daily Conversations',
      description: 'Mastering the art of small talk.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBVj_lokd6L7BOqhCunLKewRE4HjBfnj2hmf6psUzbRI687tAAoG0Mp0FrhHAi03yTP7GZdgVrGHVrq2xHKZxRbYqIYFcR_aiMwH6NKjWLF7IRQHAG5i130W8-ax27Hd4FJcn38iVKJtDQmeupTfQcKtxtw5Y17IzAdoB5EYjFicoGeJM9PtYZBJ56ddvVJsjXHSKBVM8-H0H-pwpmA8-Pk2XXM4T7r9qYdqJ1Bf2Hq9awG-CRZ5lb4dJFE5nrr173UZL-3Dens0wr1',
      duration: '15m',
      level: 'All Levels',
      isTrending: true,
    ),
  ];
});
