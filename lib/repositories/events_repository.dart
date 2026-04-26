import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';


class EventRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthRepository _authRepository;

  EventRepository(this._authRepository);
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

  // Получить все мероприятия пользователя
  Future<List<Map<String, dynamic>>> getUserEvents() async {
    try {
      final user = await _authRepository.getCurrentUser();
      final userId = user?['id'];
      final response = await _supabase.rpc(
          'get_user_events',
          params: {
            "p_user_id": userId
          }
      );

      if (response != null && response.isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }


  // Добавление в календарь мероприятия
  Future<void> addEventToCalendar(String eventId) async {
    try {
      final user = await _authRepository.getCurrentUser();
      final userId = user?['id'];
      await _supabase.from('user_event').insert({
        'user_id': userId,
        'event_id': eventId,
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Получить информацию о мероприятии
  Future<Map<String, dynamic>> getEventById(String eventId) async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
          *,
          category:category_id (
            id,
            name
          )
        ''')
          .eq('id', eventId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Мероприятие не найдено');
      }

      if (response['category'] != null) {
        response['category'] = response['category']['name'];
      }

      return response;
    } catch (e) {
      print('Error getting event: $e');
      rethrow;
    }
  }

  // Проверить, находится ли мероприятие в календаре у пользователя
  Future<bool> isEventInCalendar(String eventId, String userId) async {
    try {
      final response = await _supabase
          .from('user_event')
          .select('id')
          .eq('user_id', userId)
          .eq('event_id', eventId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking calendar: $e');
      return false;
    }
  }

  // Убрать мероприятие из календаря пользователя
  Future<void> removeEventFromCalendar(String eventId) async {
    try {
      final user = await _authRepository.getCurrentUser();
      final userId = user?['id'];
      await _supabase
          .from('user_event')
          .delete()
          .eq('user_id', userId)
          .eq('event_id', eventId);

    } catch (e) {
      rethrow;
    }
  }
}
