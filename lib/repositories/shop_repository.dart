import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


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
}
