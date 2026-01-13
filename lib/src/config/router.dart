import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:use_up/src/features/dashboard/dashboard_screen.dart';
import 'package:use_up/src/features/settings/settings_screen.dart';
import 'package:use_up/src/features/inventory/add_item_screen.dart';

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
    ],
  );
});
