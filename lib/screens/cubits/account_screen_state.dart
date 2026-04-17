abstract class AccountState {}

class AccountInfoState extends AccountState {
  final String fullname;
  final int points;

  AccountInfoState({
    required this.fullname,
    required this.points
  });
}