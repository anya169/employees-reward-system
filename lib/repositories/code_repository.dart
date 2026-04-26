import 'package:supabase_flutter/supabase_flutter.dart';


class CodeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

   // Активация введенного кода
  Future<Map<String, dynamic>> activateEventCode(String code, String userId) async {
    try {
      final codeData = await _supabase
          .from('code')
          .select()
          .eq('code', code)
          .eq('is_used', false)
          .eq('is_active', true)
          .maybeSingle();

      if (codeData == null) {
        return {'error': 'Код не найден или не активен'};
      }

      // Отмечаем код как использованный
      await _supabase
          .from('code')
          .update({
        'is_used': true,
        'used_by': userId,
      })
          .eq('id', codeData['id']);

      // Начисляем баллы пользователю
      final eventId = codeData['event_id'];
      final eventData = await _supabase
          .from('events')
          .select('points, title')
          .eq('id', eventId)
          .maybeSingle();

      final pointsToAdd = eventData?['points'];
      final eventTitle = eventData?['title'];

      final userData = await _supabase
          .from('users')
          .select('points, current_points')
          .eq('id', userId)
          .maybeSingle();
      final currentPoints = userData?['current_points'];
      final newCurrentPoints = currentPoints + pointsToAdd;

      final points = userData?['points'];
      final newPoints = points + pointsToAdd;

      // Обновляем баллы пользователя
      await _supabase
          .from('users')
          .update({'points': newPoints, 'current_points': newCurrentPoints})
          .eq('id', userId);

      return {
        'success': true,
        'message': 'Код активирован! Начислено $pointsToAdd баллов за мероприятие $eventTitle',
        'points_added': pointsToAdd,
        'current_points': newCurrentPoints,
        'points': newPoints,
        'total_points': newPoints,
      };

    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

}
