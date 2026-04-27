import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';

class RankingRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthRepository _authRepository;

  RankingRepository(this._authRepository);

  // Получить все топы
  Future<Map<String, dynamic>> getRankings() async {
    try {
      final user = await _authRepository.getCurrentUser();
      final userId = user?['id'];

      // Получаем все использованные коды со всеми пользователями
      final allCodes = await _supabase
          .from('code')
          .select('''
          used_by:used_by(
            id,
            full_name,
            branch,
            position,
            points
          ),
          event:event_id(
            points,
            title,
            category:category_id(name)
          )
        ''');
      print('Получено кодов: ${allCodes.length}');
      // Группируем баллы по пользователям и категориям
      final Map<String, Map<String, dynamic>> userStats = {};

      for (var code in allCodes) {
        final user = code['used_by'] as Map<String, dynamic>;
        final event = code['event'] as Map<String, dynamic>;

        final userId_code = user['id'];
        final category = event['category']['name'] as String;
        final points = event['points'] as int;
        print('$category $points');
        if (!userStats.containsKey(userId_code)) {
          userStats[userId_code] = {
            'id': userId_code,
            'full_name': user['full_name'],
            'branch': user['branch'],
            'position': user['position'],
            'total_points': user['points'],
            'categories': <String, int>{},
          };
        }
        print(userStats);

        // Добавляем к баллам категории
        final categories = userStats[userId_code]!['categories'] as Map<String, int>;
        categories[category] = (categories[category] ?? 0) + points;
        print(categories[category]);
      }

      // Сортируем пользователей по общим баллам для общего рейтинга
      final sortedUsers = userStats.values.toList();
      sortedUsers.sort((a, b) => (b['total_points'] as int).compareTo(a['total_points'] as int));

      // Топ-5 общего рейтинга
      final top5General = <Map<String, dynamic>>[];
      for (int i = 0; i < sortedUsers.length && i < 5; i++) {
        final user = sortedUsers[i];
        top5General.add({
          'rank': i + 1,
          'name': user['full_name'],
          'points': user['total_points'],
          'position': user['position'],
          'branch': user['branch'],
        });
      }

      // Место текущего пользователя в общем рейтинге
      final userIndex = sortedUsers.indexWhere((user) => user['id'] == userId);
      final userGeneralRank = userIndex + 1;
      final currentUserData = userIndex != -1
          ? sortedUsers[userIndex]
          : {
        'total_points': 0,
        'full_name': '',
        'position': '',
        'branch': '',
      };

      // Получаем все уникальные категории
      final Set<String> allCategories = {};
      for (var user in userStats.values) {
        final categories = (user['categories'] as Map<String, int>).keys;
        allCategories.addAll(categories);
      }

      // Для каждой категории строим рейтинг
      final Map<String, Map<String, dynamic>> categoryRankings = {};

      for (var category in allCategories) {
        // Собираем баллы пользователей в этой категории
        final categoryUsers = <Map<String, dynamic>>[];

        for (var user in userStats.values) {
          final categories = user['categories'] as Map<String, int>;
          final pointsInCategory = categories[category] ?? 0;

          if (pointsInCategory > 0) {
            categoryUsers.add({
              'id': user['id'],
              'full_name': user['full_name'],
              'points': pointsInCategory,
              'branch': user['branch'],
              'position': user['position'],
            });
          }
        }

        // Сортируем по баллам в категории
        categoryUsers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));

        // Топ-5 в категории
        final top5Category = <Map<String, dynamic>>[];
        for (int i = 0; i < categoryUsers.length && i < 5; i++) {
          final user = categoryUsers[i];
          top5Category.add({
            'rank': i + 1,
            'name': user['full_name'],
            'points': user['points'],
            'position': user['position'],
            'branch': user['branch'],
          });
        }

        // Место текущего пользователя в категории
        final userCategoryIndex = categoryUsers.indexWhere((user) => user['id'] == userId);
        final userCategoryRank = userCategoryIndex + 1;
        final userCategoryPoints = userCategoryIndex != -1
            ? categoryUsers[userCategoryIndex]['points']
            : 0;

        categoryRankings[category] = {
          'top5': top5Category,
          'userRank': userCategoryRank > 0 ? userCategoryRank : null,
          'userPoints': userCategoryPoints,
        };
      }

      return {
        'general': {
          'top5': top5General,
          'userRank': userGeneralRank,
          'userPoints': currentUserData['total_points'] ?? 0,
          'userName': currentUserData['full_name'] ?? '',
          'userPosition': currentUserData['position'],
          'userBranch': currentUserData['branch'],
        },
        'categories': categoryRankings,
        'allCategories': allCategories.toList(),
      };
    } catch (e) {
      print('Error getting rankings: $e');
      return {};
    }
  }
}