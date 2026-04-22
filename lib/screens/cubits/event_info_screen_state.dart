abstract class EventState {}

class EventLoadingState extends EventState {}

class EventInfoState extends EventState {
  final int id;
  final String name;
  final String description;
  final String imageName;
  final int eventPoints;
  final String date;

  EventInfoState({
    required this.id,
    required this.name,
    required this.description,
    required this.imageName,
    required this.eventPoints,
    required this.date
  });
}