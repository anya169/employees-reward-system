import 'package:individual_project/screens/cubits/account_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({required Map<String, dynamic> user})
      : super(AccountInfoState(
        fullname: user['full_name'],
        points: user['points'],
        currentPoints: user['current_points'],
        branch: user['branch'],
        position: user['position']
      )
  );
  void updatePoints(int newPoints, int newCurrentPoints) {
    if (state is AccountInfoState) {
      final currentState = state as AccountInfoState;
      emit(AccountInfoState(
        fullname: currentState.fullname,
        points: newPoints,
        currentPoints: newCurrentPoints,
        branch: currentState.branch,
        position: currentState.position,
      ));
    }
  }
}