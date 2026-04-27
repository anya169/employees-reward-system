import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";
import "../components/calendar_card.dart";
import "../repositories/events_repository.dart";
import '../styles/app_colors.dart';
import "cubits/calendar_screen_cubit.dart";
import "cubits/calendar_screen_state.dart";



class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventRepository = Provider.of<EventRepository>(context);

    return Scaffold(
      backgroundColor: AppColors.blueExtraLight,
      appBar: AppBar(
        title: const Text('Мои мероприятия'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          if (state is CalendarLoadingState){
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CalendarInfoState) {
            final events = state.eventsArray;
            if (events.isEmpty){
              return Center(
                  child:Text("Вы еще не добавили ни одно мероприятие себе в календарь", style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,)
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CalendarCard(
                        id: event['id'],
                        name: event['title'],
                        date: event['event_date'],
                        eventRepository: eventRepository,
                      ),
                    );
                  },
                ),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}