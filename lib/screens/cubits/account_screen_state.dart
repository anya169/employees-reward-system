abstract class AccountState {}

class AccountInfoState extends AccountState {
  final String fullname;
  final int points;
  final int currentPoints;
  final String? branch;
  final String? position;

  AccountInfoState({
    required this.fullname,
    required this.points,
    required this.currentPoints,
    this.position,
    this.branch,

  });
}