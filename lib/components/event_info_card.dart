import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/events_repository.dart';
import '../screens/cubits/auth_screen_cubit.dart';
import '../screens/cubits/auth_screen_state.dart';
import '../screens/cubits/calendar_screen_cubit.dart';
import '../styles/app_colors.dart';
import '../styles/theme.dart';

class EventInfoCard extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String imageName;
  final int eventPoints;
  final String date;
  final EventRepository eventRepository;

  const EventInfoCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageName,
    required this.eventPoints,
    required this.date,
    required this.eventRepository,
  });

  @override
  State<EventInfoCard> createState() => _EventInfoCardState();
}

class _EventInfoCardState extends State<EventInfoCard> {
  bool _isInCalendar = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfInCalendar();
  }

  Future<void> _checkIfInCalendar() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessState) {
      final userId = authState.user['id'] as String;
      final isInCalendar = await widget.eventRepository.isEventInCalendar(widget.id, userId);
      setState(() {
        _isInCalendar = isInCalendar;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToCalendar() async {
    await widget.eventRepository.addEventToCalendar(widget.id);

    setState(() {
      _isInCalendar = true;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Мероприятие добавлено в календарь')),
      );
      context.read<CalendarCubit>().getUserEvents();
    }
    }


  Future<void> _removeFromCalendar() async {

    await widget.eventRepository.removeEventFromCalendar(widget.id);

    setState(() {
      _isInCalendar = false;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Мероприятие удалено из календаря')),
      );
      context.read<CalendarCubit>().getUserEvents();
    }

  }

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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.imageName,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
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
                  "${widget.date} | ${widget.name}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const Divider(color: AppColors.white, thickness: 1),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.white, thickness: 1),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'За мероприятие начисляется ${widget.eventPoints} баллов',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_isInCalendar)
            ElevatedButton(
              style: AppTheme.tertiaryButton,
              onPressed: _removeFromCalendar,
              child: const Text(
                "Удалить из календаря",
                style: TextStyle(color: AppColors.white),
              ),
            )
          else
            ElevatedButton(
              style: AppTheme.primaryButton,
              onPressed: _addToCalendar,
              child: const Text("Добавить мероприятие в свой календарь"),
            ),
        ],
      ),
    );
  }
}