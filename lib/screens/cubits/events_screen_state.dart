abstract class EventsState {}

class EventsLoadingState extends EventsState {}

class EventsInfoState extends EventsState {
  final List<Map<String, dynamic>> eventsArray;

  EventsInfoState({
    required this.eventsArray
  });
}