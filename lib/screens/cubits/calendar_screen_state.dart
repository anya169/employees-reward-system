abstract class CalendarState {}

class CalendarLoadingState extends CalendarState {}

class CalendarInfoState extends CalendarState {
  final List<Map<String, dynamic>> eventsArray;

  CalendarInfoState({
    required this.eventsArray
  });
}