import 'package:individual_project/screens/cubits/account_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({required Map<String, dynamic> user})
      : super(AccountInfoState(
        fullname: user['full_name'],
        points: user['points'] ?? 0,
      )
  );
}