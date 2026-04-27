import 'package:individual_project/screens/cubits/account_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/shop_repository.dart';

class AccountCubit extends Cubit<AccountState> {
  final ShopRepository _shopRepository = ShopRepository();

  AccountCubit({required Map<String, dynamic> user})
      : super(AccountInfoState(
        fullname: user['full_name'],
        points: user['points'],
        currentPoints: user['current_points'],
        branch: user['branch'],
        position: user['position'],
        codes: []
      )
  ){
    loadCodes(user['id']);
  }

  Future<void> loadCodes(String userId) async {
    final codes = await _shopRepository.getCurrentCodes(userId);
    if (state is AccountInfoState) {
      final currentState = state as AccountInfoState;
      emit(AccountInfoState(
          fullname: currentState.fullname,
          points: currentState.points,
          currentPoints: currentState.currentPoints,
          branch: currentState.branch,
          position: currentState.position,
          codes: codes
      ));
    }
  }

  Future<void> updatePointsAndRefreshCodes({
    int? newPoints,
    required int newCurrentPoints,
    required String userId
  }) async {
    final updatedCodes = await _shopRepository.getCurrentCodes(userId);

    if (state is AccountInfoState) {
      final currentState = state as AccountInfoState;
      emit(AccountInfoState(
          fullname: currentState.fullname,
          points: newPoints ?? currentState.points,
          currentPoints: newCurrentPoints,
          branch: currentState.branch,
          position: currentState.position,
          codes: updatedCodes
      ));
    }
  }

}