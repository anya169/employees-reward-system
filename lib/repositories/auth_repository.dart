import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _userIdKey = 'user_id';

  // Вход
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _supabase.rpc(
        'check_user_login',
        params: {
          'p_username': username,
          'p_password': password,
        },
      );
      if (response != null && response.isNotEmpty) {
        await _saveUserId(response[0]['id']);
        return response[0];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  // Выход из учетки
  Future<void> logout() async {
    await _clearUserId();  // очищаем сохранённый ID
  }

  // Получить сохранённого пользователя (для авто-входа)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userId = await _getSavedUserId();
      if (userId == null) return null;

      final response = await _supabase.rpc(
        'get_user_by_id',
        params: {'p_id': userId},
      );

      if (response != null && response.isNotEmpty) {
        return response[0];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Получить ID пользователя
  Future<String?> _getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Сохранить ID пользователя
  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Очищение из хранилища при выходе
  Future<void> _clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}