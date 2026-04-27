import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:math';

String generateUniqueCode() {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();

  return String.fromCharCodes(
      Iterable.generate(
          6,
              (_) => characters.codeUnitAt(random.nextInt(characters.length))
      )
  );
}

class ShopRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Получить все доступные товары
  Future<List<Map<String, dynamic>>> getCurrentProducts() async {
    try {
      final response = await _supabase.rpc(
          'get_products'
      );

      if (response != null && response.isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Купить товар
  Future<Map<String, dynamic>> buyProduct(String productId,
      String userId) async {
    try {
      final productData = await _supabase
          .from('products')
          .select()
          .eq('id', productId)
          .maybeSingle();

      if (productData == null) {
        return {'error': 'Извините, товар закончился'};
      }

      final userData = await _supabase
          .from('users')
          .select('current_points')
          .eq('id', userId)
          .maybeSingle();

      final currentPoints = userData?['current_points'] as int;
      final price = productData['price'] as int;
      if (currentPoints < price) {
        return {'error': 'Извините, у вас недостаточно баллов'};
      }

      final newCurrentPoints = currentPoints - price;
      await _supabase
          .from('users')
          .update({'current_points': newCurrentPoints})
          .eq('id', userId);

      final code = generateUniqueCode();
      await _supabase.from('user_product').insert({
        'user_id': userId,
        'product_id': productId,
        'code': code
      });

      final count = productData['count'] as int;
      final newCount = count - 1;
      await _supabase
          .from('products')
          .update({'count': newCount})
          .eq('id', productId);

      return {
        'success': true,
        'message': 'Поздравляем с покупкой! Код для предъявления администратору добавлен в ваш личный кабинет',
        'current_points': newCurrentPoints
      };
    } catch (e) {
      return {'error': 'Произошла непредвиденная ошибка, повторите снова'};
    }
  }

  // Получить все коды пользователя
  Future<List<Map<String, dynamic>>> getCurrentCodes(String userId) async {
    try {
      final response = await _supabase
          .from('user_product')
          .select('*, product:product_id(*)')
          .eq('user_id', userId)
          .eq('is_used', false);

      if (response != null && response.isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
