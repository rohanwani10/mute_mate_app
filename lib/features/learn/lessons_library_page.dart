import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import 'models/learn_models.dart';
import 'video_player_page.dart';

// ─── Data ────────────────────────────────────────────────────────────────────

class LessonLibraryItem {
  final String title;
  final String duration;
  final String level;
  final String imageUrl;
  final String category;
  final String videoPath; // asset path e.g. 'assets/videos/ch1_v1.mp4'
  final double? progress; // null = not started
  bool isBookmarked;

  LessonLibraryItem({
    required this.title,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.category,
    required this.videoPath,
    this.progress,
    this.isBookmarked = false,
  });

  /// Convert to the Lesson model that VideoPlayerPage accepts.
  Lesson toLesson() => Lesson(
    id: title.hashCode.toString(),
    title: title,
    description: '$category lesson',
    imageUrl: imageUrl,
    duration: duration,
    level: level,
  );
}

final _allLessons = [
  // ── Basics (ch1) ──────────────────────────────────────────────────────────
  LessonLibraryItem(
    title: 'Basic Greetings',
    duration: '5 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCEDDYC--wPnCLOUK1-9xFy-u8hDCrV2wyt2mmbZLffFpXpV_xY_JLLkJUNqfsiARTq2dXB0dy-REZYgCWtKeKJN6HoRfB9nGFnYV9I1m3IoA2DhTeMfjoOOMaKvkZA9taK_veOae-8L0FMKqZ8dyqbYI7y6Fl6Jh-IRSSCc57YslAuNuxhmTq1gLC5FRrRrEF_v02jQHXPPjDrE50uZ-SPWwAHsI55gWOeffL8Eo6h6I8XplFeA10nraLwNbPXAoeDz7iIiOd2VA09',
    category: 'Basics',
    videoPath: 'assets/videos/ch1_v1.mp4',
    progress: 0.65,
  ),
  LessonLibraryItem(
    title: 'Family & Friends',
    duration: '8 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCehUOuDPo5jhF_vefanKd-Zi5fAq4yz5qPbb59YetKkdygeoXlYulWG1YWF-gRZeT9I4S2zdrA-OUbRb59aWz-SECBMU64F9a037sILnpmw9VOMJw4xWgVcS0JtlQXlH_1Zs0qZ8udgGHwGlx0jtfxv-IpCu7CMG2X7vmQv93TZpMS5-LxIZaYwpgpYlEp2Uea7hVTLroUTZ1ST6RLdURv3Gfj13jA2y3E4hiq1Lu5PBSpHiScIeZIXfSNWLPMG6V8yr0Q5qWiD675',
    category: 'Basics',
    videoPath: 'assets/videos/ch1_v2.mp4',
  ),
  LessonLibraryItem(
    title: 'Numbers 1–10',
    duration: '4 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBdZEZw6t4_DwLnGg1zD0eX3gm7vhmHmI8A7f-pn7NYie4CHPs2srGNPXNzlgS-0SRUGkHbE7GP8fyQ_5dtVvmSLvjsisYCzOQOQafEv7wVkW0WEVDdxGx-k3bv8y0dxmIOjgLhXH3pJE0CuvWWav9Vv24i7J84WtanN0Tg0LqtCfcpMMLtU4ri9pwGk9XyRT-z2Mm6qa0mBD3rFal7leV52I5l2Cycn7br8UBhinmj1pxlnzxu-yjXvzjsj4DZnlD8Ip7lYBZCbaIf',
    category: 'Basics',
    videoPath: 'assets/videos/ch1_v3.mp4',
    isBookmarked: true,
  ),
  LessonLibraryItem(
    title: 'Colours & Shapes',
    duration: '6 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDRny-kqdaSZMczNyU1wmKK38wfAtiku6810EpLhVSJQ7E0u5dzbJp8kSEEP3CfH4DlLu7pbFikhGd6f3CELJtbkID7-I5jBha7JF7PK19bA6AEjkTsB2okINEihQMp8NklnETq93TkAA1vNytvuQoXHAJsBGWfjlZvmJdCtqomzMh7pZ4FrAyZtBMoHZLZNSiZSQtA8210Pryi-bx4Y6UphZnJl8WkV6nkA6A4K8xox718WIUaPuFpB7PZio8n9J7PlnAbj0w1ZBU3',
    category: 'Basics',
    videoPath: 'assets/videos/ch1_v4.mp4',
  ),
  LessonLibraryItem(
    title: 'Days of the Week',
    duration: '7 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCtbVaYR5MnOzjASwqxYJAyk9acYYe-FVPMbXs8NlLWEA8calxmLyP8F-QaGuiNoCXglJcGDVDepkRyR9gGnX_LRpAJDpTsAuPgOGCb76TKjz7J-qiemrKgCT-Po1JzdChcttgYZAh47ZJhuIS4ZR6nG6B7XYhg5V_ZEd2tJ8RRba6vYbIwAszJg3oKIlhMmd2qUhto_U37-mnkQB2PgKdrh17hivobjGs1QWsSs_i1XoOfRlmyQvUPc0aEEThRFNYuDCsJSaj5zj2x',
    category: 'Basics',
    videoPath: 'assets/videos/ch1_v5.mp4',
  ),
  LessonLibraryItem(
    title: 'Alphabet A–Z',
    duration: '10 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBVj_lokd6L7BOqhCunLKewRE4HjBfnj2hmf6psUzbRI687tAAoG0Mp0FrhHAi03yTP7GZdgVrGHVrq2xHKZxRbYqIYFcR_aiMwH6NKjWLF7IRQHAG5i130W8-ax27Hd4FJcn38iVKJtDQmeupTfQcKtxtw5Y17IzAdoB5EYjFicoGeJM9PtYZBJ56ddvVJsjXHSKBVM8-H0H-pwpmA8-Pk2XXM4T7r9qYdqJ1Bf2Hq9awG-CRZ5lb4dJFE5nrr173UZL-3Dens0wr1',
    category: 'Basics',
    videoPath: 'assets/videos/ch1_v6.mp4',
  ),

  // ── Daily Life (ch2) ──────────────────────────────────────────────────────
  LessonLibraryItem(
    title: 'Morning Routine',
    duration: '6 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDRny-kqdaSZMczNyU1wmKK38wfAtiku6810EpLhVSJQ7E0u5dzbJp8kSEEP3CfH4DlLu7pbFikhGd6f3CELJtbkID7-I5jBha7JF7PK19bA6AEjkTsB2okINEihQMp8NklnETq93TkAA1vNytvuQoXHAJsBGWfjlZvmJdCtqomzMh7pZ4FrAyZtBMoHZLZNSiZSQtA8210Pryi-bx4Y6UphZnJl8WkV6nkA6A4K8xox718WIUaPuFpB7PZio8n9J7PlnAbj0w1ZBU3',
    category: 'Daily Life',
    videoPath: 'assets/videos/ch2_v2.mp4',
    progress: 0.3,
  ),
  LessonLibraryItem(
    title: 'Ordering at a Café',
    duration: '12 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCtbVaYR5MnOzjASwqxYJAyk9acYYe-FVPMbXs8NlLWEA8calxmLyP8F-QaGuiNoCXglJcGDVDepkRyR9gGnX_LRpAJDpTsAuPgOGCb76TKjz7J-qiemrKgCT-Po1JzdChcttgYZAh47ZJhuIS4ZR6nG6B7XYhg5V_ZEd2tJ8RRba6vYbIwAszJg3oKIlhMmd2qUhto_U37-mnkQB2PgKdrh17hivobjGs1QWsSs_i1XoOfRlmyQvUPc0aEEThRFNYuDCsJSaj5zj2x',
    category: 'Daily Life',
    videoPath: 'assets/videos/ch2_v3.mp4',
  ),
  LessonLibraryItem(
    title: 'Shopping & Prices',
    duration: '9 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDYZZFO9gIOoGlScMMKRvSqQtDHBZpK2gx81cJVwaDPvMhzbwYi_1RJmXzn_1ASeNuoagn6iuuRipsZvQ3sKwueIntpAA--BR2pxUP2NOPRSWGVekR1SjVJVdt0Ng5d5I2NmG2H0RYYJyrBHiQTTOxxY5VrwyWUbFGVASufFqBJf8woXkUQ4SDtemZ6uaoEX6WnfWoq2OT9OQgAT3OhHP20CiqWja5FjCAC4ok3-h7rRTk8EWgf5yhJPbVyvXIecFlLD-B7yyz6Es--',
    category: 'Daily Life',
    videoPath: 'assets/videos/ch2_v4.mp4',
  ),
  LessonLibraryItem(
    title: 'Dining Out',
    duration: '8 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAnQg5d3XiNJf6dJGqBb3p545eVerXfReDNj2JY0BowQMg1PPZ4qt5SbPQ6Xy-WH6IwikEeBFl9kc3Z2MlFHA7K6jf7DXLeDGAEtURggyDtGGaUz3VOf9JimDuGe8W8ZCgDEkLf3RZYudKXxDlEO2_aMraDoIfOswqsiFRk-kVgjT4hdPTYRb_hhal1M60azsC6hMzF7llmeQRFmCLo-N695fLncTwJOMuiDZOIN8JV_pjtH9n2iTaaj8E-TGZK86dPwtZrw6_PuZAK',
    category: 'Daily Life',
    videoPath: 'assets/videos/ch2_v5.mp4',
  ),
  LessonLibraryItem(
    title: 'Transport & Directions',
    duration: '11 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBdZEZw6t4_DwLnGg1zD0eX3gm7vhmHmI8A7f-pn7NYie4CHPs2srGNPXNzlgS-0SRUGkHbE7GP8fyQ_5dtVvmSLvjsisYCzOQOQafEv7wVkW0WEVDdxGx-k3bv8y0dxmIOjgLhXH3pJE0CuvWWav9Vv24i7J84WtanN0Tg0LqtCfcpMMLtU4ri9pwGk9XyRT-z2Mm6qa0mBD3rFal7leV52I5l2Cycn7br8UBhinmj1pxlnzxu-yjXvzjsj4DZnlD8Ip7lYBZCbaIf',
    category: 'Daily Life',
    videoPath: 'assets/videos/ch2_v6.mp4',
  ),

  // ── Emergency (ch3) ───────────────────────────────────────────────────────
  LessonLibraryItem(
    title: 'Emergency Help',
    duration: '8 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAhQgqJAYrMKNt0c4r1zX0YJn-dVNIY4mtDWVcVj35zmWM7NQ8WIJ8adMqTYGCI5Vxue9IBUgzPz0WwJ93SZSvwfYRlq5Z1BOTYegQNBKDd1eIj2my-rHvhd-D2FHlD_vUPeywwZnrv6tmEs2wGtJ7jKte9NH0oJqGp3oQTL7tlT_Koq9xu1K85q3mIuPMJsjXfYKdMOLHknlYUqOnA97VAwEUQtJmc3GAiMWq7MfZAw3A5yKVZn-7Lai1QqWBCjOVh6OA8wUr_qWfT',
    category: 'Emergency',
    videoPath: 'assets/videos/ch3_v1.mp4',
    progress: 0.1,
  ),
  LessonLibraryItem(
    title: 'Doctor Visit',
    duration: '10 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBVj_lokd6L7BOqhCunLKewRE4HjBfnj2hmf6psUzbRI687tAAoG0Mp0FrhHAi03yTP7GZdgVrGHVrq2xHKZxRbYqIYFcR_aiMwH6NKjWLF7IRQHAG5i130W8-ax27Hd4FJcn38iVKJtDQmeupTfQcKtxtw5Y17IzAdoB5EYjFicoGeJM9PtYZBJ56ddvVJsjXHSKBVM8-H0H-pwpmA8-Pk2XXM4T7r9qYdqJ1Bf2Hq9awG-CRZ5lb4dJFE5nrr173UZL-3Dens0wr1',
    category: 'Emergency',
    videoPath: 'assets/videos/ch3_v2.mp4',
  ),
  LessonLibraryItem(
    title: 'Calling for Help',
    duration: '7 mins',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCEDDYC--wPnCLOUK1-9xFy-u8hDCrV2wyt2mmbZLffFpXpV_xY_JLLkJUNqfsiARTq2dXB0dy-REZYgCWtKeKJN6HoRfB9nGFnYV9I1m3IoA2DhTeMfjoOOMaKvkZA9taK_veOae-8L0FMKqZ8dyqbYI7y6Fl6Jh-IRSSCc57YslAuNuxhmTq1gLC5FRrRrEF_v02jQHXPPjDrE50uZ-SPWwAHsI55gWOeffL8Eo6h6I8XplFeA10nraLwNbPXAoeDz7iIiOd2VA09',
    category: 'Emergency',
    videoPath: 'assets/videos/ch3_v3.mp4',
  ),
  LessonLibraryItem(
    title: 'Pain & Symptoms',
    duration: '9 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCtbVaYR5MnOzjASwqxYJAyk9acYYe-FVPMbXs8NlLWEA8calxmLyP8F-QaGuiNoCXglJcGDVDepkRyR9gGnX_LRpAJDpTsAuPgOGCb76TKjz7J-qiemrKgCT-Po1JzdChcttgYZAh47ZJhuIS4ZR6nG6B7XYhg5V_ZEd2tJ8RRba6vYbIwAszJg3oKIlhMmd2qUhto_U37-mnkQB2PgKdrh17hivobjGs1QWsSs_i1XoOfRlmyQvUPc0aEEThRFNYuDCsJSaj5zj2x',
    category: 'Emergency',
    videoPath: 'assets/videos/ch3_v4.mp4',
  ),

  // ── Work (ch4) ────────────────────────────────────────────────────────────
  LessonLibraryItem(
    title: 'Office Small Talk',
    duration: '7 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDYZZFO9gIOoGlScMMKRvSqQtDHBZpK2gx81cJVwaDPvMhzbwYi_1RJmXzn_1ASeNuoagn6iuuRipsZvQ3sKwueIntpAA--BR2pxUP2NOPRSWGVekR1SjVJVdt0Ng5d5I2NmG2H0RYYJyrBHiQTTOxxY5VrwyWUbFGVASufFqBJf8woXkUQ4SDtemZ6uaoEX6WnfWoq2OT9OQgAT3OhHP20CiqWja5FjCAC4ok3-h7rRTk8EWgf5yhJPbVyvXIecFlLD-B7yyz6Es--',
    category: 'Work',
    videoPath: 'assets/videos/ch4_v1.mp4',
  ),
  LessonLibraryItem(
    title: 'Meeting & Presentations',
    duration: '15 mins',
    level: 'Advanced',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAnQg5d3XiNJf6dJGqBb3p545eVerXfReDNj2JY0BowQMg1PPZ4qt5SbPQ6Xy-WH6IwikEeBFl9kc3Z2MlFHA7K6jf7DXLeDGAEtURggyDtGGaUz3VOf9JimDuGe8W8ZCgDEkLf3RZYudKXxDlEO2_aMraDoIfOswqsiFRk-kVgjT4hdPTYRb_hhal1M60azsC6hMzF7llmeQRFmCLo-N695fLncTwJOMuiDZOIN8JV_pjtH9n2iTaaj8E-TGZK86dPwtZrw6_PuZAK',
    category: 'Work',
    videoPath: 'assets/videos/ch4_v2.mp4',
  ),
  LessonLibraryItem(
    title: 'Asking for Feedback',
    duration: '6 mins',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBdZEZw6t4_DwLnGg1zD0eX3gm7vhmHmI8A7f-pn7NYie4CHPs2srGNPXNzlgS-0SRUGkHbE7GP8fyQ_5dtVvmSLvjsisYCzOQOQafEv7wVkW0WEVDdxGx-k3bv8y0dxmIOjgLhXH3pJE0CuvWWav9Vv24i7J84WtanN0Tg0LqtCfcpMMLtU4ri9pwGk9XyRT-z2Mm6qa0mBD3rFal7leV52I5l2Cycn7br8UBhinmj1pxlnzxu-yjXvzjsj4DZnlD8Ip7lYBZCbaIf',
    category: 'Work',
    videoPath: 'assets/videos/ch4_v3.mp4',
  ),
  LessonLibraryItem(
    title: 'Team Collaboration',
    duration: '12 mins',
    level: 'Advanced',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCehUOuDPo5jhF_vefanKd-Zi5fAq4yz5qPbb59YetKkdygeoXlYulWG1YWF-gRZeT9I4S2zdrA-OUbRb59aWz-SECBMU64F9a037sILnpmw9VOMJw4xWgVcS0JtlQXlH_1Zs0qZ8udgGHwGlx0jtfxv-IpCu7CMG2X7vmQv93TZpMS5-LxIZaYwpgpYlEp2Uea7hVTLroUTZ1ST6RLdURv3Gfj13jA2y3E4hiq1Lu5PBSpHiScIeZIXfSNWLPMG6V8yr0Q5qWiD675',
    category: 'Work',
    videoPath: 'assets/videos/ch4_v4.mp4',
  ),
];

const _categories = ['All', 'Basics', 'Daily Life', 'Emergency', 'Work'];

// ─── Page ─────────────────────────────────────────────────────────────────────

class LessonsLibraryPage extends StatefulWidget {
  /// The category to pre-select when opened from a category card.
  final String? initialCategory;
  final String? initialSearchQuery;

  const LessonsLibraryPage({
    this.initialCategory,
    this.initialSearchQuery,
    super.key,
  });

  @override
  State<LessonsLibraryPage> createState() => _LessonsLibraryPageState();
}

class _LessonsLibraryPageState extends State<LessonsLibraryPage> {
  late String _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Keep a local mutable copy so bookmark toggling persists within the session
  final List<LessonLibraryItem> _lessons = List.from(_allLessons);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
    _searchController.text = widget.initialSearchQuery ?? '';
    _searchQuery = _searchController.text.toLowerCase();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LessonLibraryItem> get _filtered {
    return _lessons.where((l) {
      final matchesCategory =
          _selectedCategory == 'All' || l.category == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          l.title.toLowerCase().contains(_searchQuery) ||
          l.category.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      // ── App Bar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Learn',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurface),
            onPressed: () => _searchFocusNode.requestFocus(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // ── Search Bar ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _SearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
              ),
            ),
          ),

          // ── Category Chips ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _CategoryChips(
              categories: _categories,
              selected: _selectedCategory,
              onSelect: (cat) => setState(() => _selectedCategory = cat),
            ),
          ),

          // ── Section Header ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended for you',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Lesson Cards ───────────────────────────────────────────────────
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 56,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No lessons found',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _LessonCard(
                      lesson: item,
                      onBookmarkToggle: () {
                        setState(() => item.isBookmarked = !item.isBookmarked);
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerPage(
                              lesson: item.toLesson(),
                              videoPath: item.videoPath,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }, childCount: filtered.length),
              ),
            ),
        ],
      ),
    );
  }

  final FocusNode _searchFocusNode = FocusNode();
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _SearchBar({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search lessons, signs, or phrases...',
          hintStyle: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.outline,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 17,
          ),
        ),
      ),
    );
  }
}

// ─── Category Chips ───────────────────────────────────────────────────────────

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = cat == selected;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: GestureDetector(
              onTap: () => onSelect(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isActive
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Lesson Card ──────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final LessonLibraryItem lesson;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.onBookmarkToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerlowest,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Thumbnail ────────────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: lesson.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceContainerHigh,
                          child: const Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                      // "In Progress" badge
                      if (lesson.progress != null)
                        Positioned(
                          bottom: 12,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              'In Progress',
                              style: TextStyle(
                                color: AppColors.onSecondaryContainer,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Details ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + meta
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule_outlined,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    lesson.duration,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: AppColors.outline.withValues(
                                        alpha: 0.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.school_outlined,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    lesson.level,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Action buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _IconBtn(
                              icon: lesson.isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: lesson.isBookmarked
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              onTap: onBookmarkToggle,
                            ),
                            _IconBtn(
                              icon: Icons.share_outlined,
                              color: AppColors.onSurfaceVariant,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ── Progress bar ─────────────────────────────────────
                    if (lesson.progress != null) ...[
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: lesson.progress,
                          minHeight: 6,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: Icon(icon, size: 22, color: color)),
      ),
    );
  }
}
