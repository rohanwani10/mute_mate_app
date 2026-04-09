import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MuteMateTab { home, translate, learn, profile, notifications }

final navIndexProvider = StateProvider<int>((ref) => 0);

final isNotificationsVisibleProvider = StateProvider<bool>((ref) => false);

final activeTabProvider = Provider<MuteMateTab>((ref) {
  final index = ref.watch(navIndexProvider);
  return MuteMateTab.values[index];
});
