import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";
import "../components/info_card.dart";
import "../repositories/ranking_repository.dart";
import '../styles/app_colors.dart';
import "cubits/ranking_screen_cubit.dart";
import "cubits/ranking_screen_state.dart";

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blueExtraLight,
        appBar: AppBar(
          title: const Text('Рейтинг'),
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          centerTitle: true,
        ),
        body: BlocBuilder<RankingCubit, RankingState>(
          builder: (context, state) {
            if (state is RankingLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RankingInfoState) {
              final generalRanking = state.generalRanking;
              final categoryRankings = state.categoryRankings;
              final allCategories = state.allCategories;

              // Создаем список для отображения
              final List<Map<String, dynamic>> displayItems = [];

              // Добавляем общий рейтинг
              displayItems.add({
                'type': 'general',
                'label': 'Общий рейтинг',
                'data': generalRanking,
              });

              // Добавляем рейтинг по категориям
              for (var category in allCategories) {
                displayItems.add({
                  'type': 'category',
                  'label': category,
                  'data': categoryRankings[category] ?? {},
                });
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 20),
                itemCount: displayItems.length,
                itemBuilder: (context, index) {
                  final item = displayItems[index];
                  final label = item['label'] as String;
                  final data = item['data'] as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InfoCard(
                      label: label,
                      content: _buildRankingContent(context, data),
                    ),
                  );
                },
              );
            }

            if (state is RankingErrorState) {
              return Center(
                child:
                    Text(
                      "Не удалось загрузить рейтинг",
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
              );
            }

            return Container();
          },
        ),
      );
  }

  Widget _buildRankingContent(BuildContext context, Map<String, dynamic> rankingData) {
    final top5 = (rankingData['top5'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    final userRank = rankingData['userRank'];

    if (top5.isEmpty && (userRank == null || userRank == 0)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            "Рейтинг пуст",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Заголовок топ-5
        if (top5.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Топ-5 участников",
            ),
          ),

        // Топ-5
        ...top5.map((user) => _buildRankingItem(
          context: context,
          rank: user['rank'],
          name: user['name'],
          points: user['points'],
          position: user['position'],
          branch: user['branch'],
        )),


      ],
    );
  }

  Widget _buildRankingItem({
    required BuildContext context,
    required int rank,
    required String name,
    required int points,
    String? position,
    String? branch,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Место
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: _getRankGradient(rank),
              shape: BoxShape.circle,
              boxShadow: rank <= 3 ? [
                BoxShadow(
                  color: _getRankColor(rank).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: rank <= 3 ? 18 : 16,
                  color: rank <= 3 ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Информация о пользователе
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (position != null && position.isNotEmpty)
                  Text(
                    position,
                    style: Theme.of(context).textTheme.labelLarge
                  ),
                if (branch != null && branch.isNotEmpty)
                  Text(
                    branch,
                    style: Theme.of(context).textTheme.labelLarge
                  ),

              ],
            ),
          ),

          // Баллы
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$points',
                  style: Theme.of(context).textTheme.bodySmall
              ),
              Text(
                'баллов',
                style: Theme.of(context).textTheme.labelLarge
              ),
            ],
          ),
        ],
      ),
    );
  }

  Gradient _getRankGradient(int rank) {
    switch (rank) {
      case 1:
        return LinearGradient(
          colors: [Colors.amber[400]!, Colors.amber[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [Colors.brown[300]!, Colors.brown[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.grey[100]!, Colors.grey[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber[700]!;
      case 2:
        return Colors.grey[600]!;
      case 3:
        return Colors.brown[600]!;
      default:
        return Colors.grey[400]!;
    }
  }
}