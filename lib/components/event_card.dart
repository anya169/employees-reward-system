import 'package:flutter/material.dart';
import '../screens/event_info_screen.dart';
import '../styles/app_colors.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String imageName;
  final int eventPoints;
  final String date;

  const EventCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageName,
    required this.eventPoints,
    required this.date
  });

  String _formatDate(String isoString) {
    try {
      final DateTime dateTime = DateTime.parse(isoString);
      return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  String _truncateDescription(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Переход на детальный экран с ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventInfoScreen(id: id, name: name, description: description, imageName: imageName, eventPoints: eventPoints, date: _formatDate(date)),
            ),
          );
        },
        child:
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 4,
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
                  Divider(
                    color: AppColors.blue,
                    thickness: 1,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      border: Border.all(color: AppColors.blue, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                      Column(
                          children: [
                            Text(
                              "$name | ${_formatDate(date)}",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              _truncateDescription(description, 100),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ]
                      ),
                  )
                ],
              )
          )
      );
  }
}