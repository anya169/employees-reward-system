abstract class RankingState {}

class RankingInitialState extends RankingState {}

class RankingLoadingState extends RankingState {}

class RankingInfoState extends RankingState {
  final Map<String, dynamic> generalRanking;
  final Map<String, Map<String, dynamic>> categoryRankings;
  final List<String> allCategories;

  RankingInfoState({
    required this.generalRanking,
    required this.categoryRankings,
    required this.allCategories,
  });
}

class RankingErrorState extends RankingState {}