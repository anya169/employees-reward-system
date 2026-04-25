import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

import '../styles/theme.dart';

class EventInfoCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String imageName;
  final int eventPoints;
  final String date;

  const EventInfoCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageName,
    required this.eventPoints,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageName,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$date | $name",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Divider(
                      color: AppColors.white,
                      thickness: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color: AppColors.white,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'За мероприятие начисляется $eventPoints баллов',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                style: AppTheme.primaryButton,
                onPressed: () {
                },
                child: const Text("Добавить мероприятие в свой календарь", softWrap: true),
              ),
            ],
          ),
    );
  }
}