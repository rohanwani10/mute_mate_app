import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationFilter { all, learning, account }

final notificationFilterProvider = StateProvider<NotificationFilter>((ref) => NotificationFilter.all);
