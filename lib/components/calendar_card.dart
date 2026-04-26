import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../repositories/events_repository.dart';
import '../screens/event_info_screen.dart';
import '../styles/app_colors.dart';

class CalendarCard extends StatelessWidget {
  final String id;
  final String name;
  final String date;
  final EventRepository eventRepository;

  const CalendarCard({
    super.key,
    required this.id,
    required this.name,
    required this.date,
    required this.eventRepository,
  });

  String _getDay(String dateTime) {
    try {
      final DateTime date = DateTime.parse(dateTime);
      return date.day.toString().padLeft(2, '0');
    } catch (e) {
      return '--';
    }
  }

  String _getMonth(String dateTime) {
    try {
      final DateTime date = DateTime.parse(dateTime);
      const months = [
        'янв', 'фев', 'мар', 'апр', 'май', 'июн',
        'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
      ];
      return months[date.month - 1];
    } catch (e) {
      return '---';
    }
  }

  String _formatDate(String isoString) {
    try {
      final DateTime dateTime = DateTime.parse(isoString);
      return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  Future<void> _navigateToEventInfo(BuildContext context) async {
    // Получаем полную информацию о мероприятии
    final event = await eventRepository.getEventById(id);
    // Переходим на детальный экран
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventInfoScreen(
          id: id,
          name: event['title'],
          description: event['description'] ?? '',
          imageName: event['image_name'] ?? '',
          eventPoints: event['points'] ?? 0,
          date: _formatDate(event['event_date']),
          eventRepository: eventRepository,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToEventInfo(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.blue,
          border: Border.all(color: AppColors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  _getDay(date),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  _getMonth(date),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 40,
              color: AppColors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}