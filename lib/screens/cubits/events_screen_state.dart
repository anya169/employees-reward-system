abstract class EventState {}

class EventLoadingState extends EventState {}

class EventInfoState extends EventState {
  final List<Map<String, dynamic>> eventsArray;

  EventInfoState({
    required this.eventsArray
  });
}