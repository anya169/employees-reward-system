import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class EventRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Получить все непрошедшие мероприятия
  Future<List<Map<String, dynamic>>> getCurrentEvents() async {
    try {
      final response = await _supabase.rpc(
          'get_upcoming_events'
      );

      if (response != null && response.isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
