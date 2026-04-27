import 'package:flutter_bloc/flutter_bloc.dart';
import 'ranking_screen_state.dart';
import '../../repositories/ranking_repository.dart';

class RankingCubit extends Cubit<RankingState> {
  final RankingRepository _rankingRepository;

  RankingCubit(RankingRepository rankingRepository)
      : _rankingRepository = rankingRepository,
        super(RankingInitialState()){
      loadRankings();
  }

  Future<void> loadRankings() async {
    emit(RankingLoadingState());
    try {
      final rankings = await _rankingRepository.getRankings();

      if (rankings.isNotEmpty) {
        emit(RankingInfoState(
          generalRanking: rankings['general'] as Map<String, dynamic>,
          categoryRankings: rankings['categories'] as Map<String, Map<String, dynamic>>,
          allCategories: rankings['allCategories'] as List<String>,
        ));
      } else {
        emit(RankingErrorState());
      }
    } catch (e) {
      emit(RankingErrorState());
    }
  }
}