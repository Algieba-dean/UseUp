import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/constants.dart';

class PreferencesRepository {
  Future<int?> getDefaultLocationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.prefDefaultLocationId);
  }

  Future<void> setDefaultLocationId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefDefaultLocationId, id);
  }

  Future<int?> getDefaultCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.prefDefaultCategoryId);
  }

  Future<void> setDefaultCategoryId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefDefaultCategoryId, id);
  }
}

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository();
});
