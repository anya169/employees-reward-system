import "package:flutter/material.dart";
import "package:individual_project/components/event_info_card.dart";
import "package:individual_project/repositories/events_repository.dart";
import "package:provider/provider.dart";
import '../styles/app_colors.dart';
import "../styles/theme.dart";

class EventInfoScreen extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String imageName;
  final int eventPoints;
  final String date;

  const EventInfoScreen({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageName,
    required this.eventPoints,
    required this.date,
    required EventRepository eventRepository,
  });

  @override
  Widget build(BuildContext context) {
    final eventRepository = Provider.of<EventRepository>(context);
    return Scaffold(
      backgroundColor: AppColors.blueExtraLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
        child:
          EventInfoCard(
              id: id,
              name: name,
              description: description,
              imageName: imageName,
              eventPoints: eventPoints,
              date: date,
              eventRepository: eventRepository,
          ),
      )
    );
  }
}