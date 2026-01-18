import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:use_up/src/features/dashboard/dashboard_screen.dart';
import 'package:use_up/src/features/settings/settings_screen.dart';
import 'package:use_up/src/features/inventory/add_item_screen.dart';
import 'package:use_up/src/features/inventory/item_detail_screen.dart';
import 'package:use_up/src/features/history/history_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: '/add', builder: (context, state) => const AddItemScreen()),
      GoRoute(
        path: '/item/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ItemDetailScreen(itemId: id);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
});
