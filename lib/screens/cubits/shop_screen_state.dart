abstract class ShopState {}

class ShopLoadingState extends ShopState {}

class ShopInfoState extends ShopState {
  final List<Map<String, dynamic>> productsArray;

  ShopInfoState({
    required this.productsArray
  });
}