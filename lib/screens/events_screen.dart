import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../components/event_card.dart";
import "../repositories/events_repository.dart";
import '../styles/app_colors.dart';
import "cubits/events_screen_cubit.dart";
import "cubits/events_screen_state.dart";
import 'package:provider/provider.dart';



class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventRepository = Provider.of<EventRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мероприятия в компании'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      backgroundColor: AppColors.blueExtraLight,
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state is EventsLoadingState){
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventsInfoState) {
            final events = state.eventsArray;
            if (events.isEmpty){
              return Center(
                child:Text("В ближайшее время не ожидаются мероприятия", style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,)
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
                      child: EventCard(
                        id: event['id'],
                        name: event['title'],
                        description: event['description'],
                        imageName: event['image_name'],
                        date: event['event_date'],
                        eventPoints: event['points'],
                        category: event["category_name"],
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