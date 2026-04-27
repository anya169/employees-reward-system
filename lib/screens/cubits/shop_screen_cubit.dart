import 'package:individual_project/repositories/shop_repository.dart';
import 'package:individual_project/screens/cubits/shop_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopRepository _shopRepository;

  ShopCubit(this._shopRepository) : super(ShopLoadingState()) {
    getCurrentShop();
  }

  // Получение текущих товаров из бд
  Future<void> getCurrentShop() async {
    final products = await _shopRepository.getCurrentProducts();
    emit(ShopInfoState(productsArray: products));
  }
}